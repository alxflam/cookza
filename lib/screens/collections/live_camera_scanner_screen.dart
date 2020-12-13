// based upon
// https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_ml_vision/example/lib/camera_preview_scanner.dart

// Copyright 2018 The Chromium Authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//    * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//    * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cookza/services/ml_kit/scanner_utils.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

enum SelectionMode { liveCamera, gallery }

class LiveCameraScannerScreen extends StatefulWidget {
  static final String id = 'liveCameraScanner';

  @override
  _LiveCameraScannerScreenState createState() =>
      _LiveCameraScannerScreenState();
}

class _LiveCameraScannerScreenState extends State<LiveCameraScannerScreen> {
  bool _isDetecting = false;
  List<Barcode> _scanResults = [];
  CameraController _camera;
  SelectionMode _mode = SelectionMode.liveCamera;
  File _galleryImage;
  bool _popped = false;

  final BarcodeDetector _detector = FirebaseVision.instance.barcodeDetector(
      BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() async {
    if (_mode != SelectionMode.liveCamera) {
      return;
    }

    CameraLensDirection _direction = CameraLensDirection.back;
    final CameraDescription description = await getCamera(_direction);
    _camera = CameraController(description, ResolutionPreset.medium);
    await _camera.initialize();

    /// unawaited intentionally
    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      if (!_isDetecting) {
        setState(() {
          // force refresh, now the camera has been initialized and the live preview should be shown
        });
      }
      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _detector.detectInImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (List<Barcode> results) {
          // only call set state if detected qrCode changed
          bool _setState = false;
          if (_scanResults.isEmpty && results.isNotEmpty) {
            _setState = true;
          } else if (_scanResults.first?.rawValue != results.first?.rawValue &&
              results.isNotEmpty) {
            _setState = true;
          }

          if (_setState) {
            setState(() {
              _scanResults = results;
              _popScreen();
            });
          }
        },
      ).whenComplete(() {
        _isDetecting = false;
      });
    });
  }

  static Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  void _popScreen() {
    /// popped member is needed as otherwise the method is called multiple times
    /// as the camera stream may still be running
    if (_scanResults.isNotEmpty && !_popped) {
      _popped = true;
      var qrCode = _scanResults.first.rawValue;
      _scanResults.clear();

      /// wait until we can navigate
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context, qrCode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  Widget _buildImage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('§QR-Code scannen'),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.getImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _mode = SelectionMode.gallery;
                    _galleryImage = File(image.path);
                  });

                  // display the image
                  var visionImage =
                      FirebaseVisionImage.fromFilePath(image.path);
                  var barcodes = await _detector.detectInImage(visionImage);

                  setState(() {
                    _scanResults = barcodes;
                    _popScreen();
                  });
                }
              }),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_mode == SelectionMode.liveCamera) {
            return _displayLiveImage();
          } else {
            return _displayGalleryImage();
          }
        },
      ),
    );
  }

  Widget _displayGalleryImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(_galleryImage), fit: BoxFit.cover),
            ),
          ),
          _checkQrCodeExistence(),
        ],
      ),
    );
  }

  Container _displayLiveImage() {
    return Container(
      constraints: BoxConstraints.expand(),
      child: _camera == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera),
                _checkQrCodeExistence(),
              ],
            ),
    );
  }

  Widget _checkQrCodeExistence() {
    if (_scanResults.isEmpty) {
      if (this._mode == SelectionMode.gallery) {
        return SimpleDialog(
          title: Icon(
            Icons.error,
            size: 50,
          ),
          backgroundColor: Color.fromARGB(150, 255, 0, 0),
          children: [
            Center(
              child: Wrap(
                children: [
                  Center(child: Text('Could not detect any QR-Code.')),
                  Center(child: Text('Please try another image.')),
                ],
              ),
            )
          ],
        );
      }
    }
    return Container();
  }

  @override
  void dispose() {
    _disposeCamera();
    super.dispose();
  }

  Future<void> _disposeCamera() async {
    await this._camera.stopImageStream();
    await _camera.dispose().then((_) {
      _detector.close();
    });
  }
}
