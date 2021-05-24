import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.title,
      required this.onImage,
      required this.hasQrCode})
      : super(key: key);

  final String title;
  final Function(InputImage inputImage) onImage;
  final Future<bool> Function(InputImage inputImage) hasQrCode;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  CameraDescription? _cameraDescription;

  @override
  void initState() {
    super.initState();
    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _switchScreenMode,
            icon: Icon(_mode == ScreenMode.liveFeed
                ? Icons.photo_library_outlined
                : Icons.camera),
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.liveFeed) {
      body = _liveFeedBody();
    } else {
      body = _galleryBody();
    }
    return body;
  }

  Widget _liveFeedBody() {
    if (_controller == null || _controller?.value.isInitialized == false) {
      return Container();
    }
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
        ],
      ),
    );
  }

  Widget _galleryBody() {
    if (_image == null) {
      return Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.photo_library_outlined),
          ),
        ),
      );
    }

    return Container(
      // constraints: const BoxConstraints.expand(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: FileImage(_image!), fit: BoxFit.contain),
            ),
          ),
          _checkQrCodeExistence(context),
        ],
      ),
    );
  }

  Future _getImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return _processPickedFile(pickedFile);
    } else {
      this._mode = ScreenMode.liveFeed;
      setState(() {});
    }
  }

  void _switchScreenMode() async {
    if (_mode == ScreenMode.liveFeed) {
      _mode = ScreenMode.gallery;
      await _stopLiveFeed();
      await _getImage();
    } else {
      _mode = ScreenMode.liveFeed;
      await _startLiveFeed();
      setState(() {});
    }
  }

  static Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  Future _startLiveFeed() async {
    CameraLensDirection _direction = CameraLensDirection.back;
    _cameraDescription = await getCamera(_direction);
    _controller = CameraController(_cameraDescription!, ResolutionPreset.medium,
        enableAudio: false);

    // ignore: unawaited_futures
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
    this._cameraDescription = null;
    this._image = null;
  }

  Future _processPickedFile(PickedFile pickedFile) async {
    setState(() {
      _image = File(pickedFile.path);
    });
    final inputImage = InputImage.fromFilePath(pickedFile.path);
    widget.onImage(inputImage);
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final imageRotation = InputImageRotationMethods.fromRawValue(
            _cameraDescription!.sensorOrientation) ??
        InputImageRotation.Rotation_0deg;

    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }

  Widget _checkQrCodeExistence(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: SimpleDialog(
        title: Icon(
          Icons.error,
          size: 50,
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        children: [
          Center(
            child: Wrap(
              children: [
                Center(
                  child: Text(AppLocalizations.of(context).noQRCodeDetected),
                ),
                Center(
                  child: Text(AppLocalizations.of(context).tryAnotherImage),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
