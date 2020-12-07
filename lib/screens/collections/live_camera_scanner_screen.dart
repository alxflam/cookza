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

import 'package:camera/camera.dart';
import 'package:cookza/services/ml_kit/scanner_utils.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class LiveCameraScannerScreen extends StatefulWidget {
  static final String id = 'liveCameraScanner';

  @override
  _LiveCameraScannerScreenState createState() =>
      _LiveCameraScannerScreenState();
}

class _LiveCameraScannerScreenState extends State<LiveCameraScannerScreen> {
  bool _isDetecting = false;
  List<Barcode> _scanResults;
  CameraController _camera;

  final BarcodeDetector _detector = FirebaseVision.instance.barcodeDetector(
      BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() async {
    CameraLensDirection _direction = CameraLensDirection.back;
    final CameraDescription description = await getCamera(_direction);
    _camera = CameraController(description, ResolutionPreset.medium);
    await _camera.initialize();

    /// unawaited intentionally
    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _detector.detectInImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          setState(() {
            _scanResults = results;
            if (_scanResults.isNotEmpty) {
              Future.delayed(Duration.zero, () {
                Navigator.pop(context, _scanResults.first.rawValue);
              });
            }
          });
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

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera),
                _highlightFoundQrCodes(),
              ],
            ),
    );
  }

  Widget _highlightFoundQrCodes() {
    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return Container();
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    painter = BarcodeDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      _detector.close();
    });

    super.dispose();
  }
}

class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(this.absoluteImageSize, this.barcodeLocations);

  final Size absoluteImageSize;
  final List<Barcode> barcodeLocations;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(Barcode barcode) {
      return Rect.fromLTRB(
        barcode.boundingBox.left * scaleX,
        barcode.boundingBox.top * scaleY,
        barcode.boundingBox.right * scaleX,
        barcode.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (Barcode barcode in barcodeLocations) {
      paint.color = Colors.green;
      canvas.drawRect(scaleRect(barcode), paint);
    }
  }

  @override
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.barcodeLocations != barcodeLocations;
  }
}
