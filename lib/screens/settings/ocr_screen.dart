import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OCRTestScreen extends StatefulWidget {
  static final String id = 'ocrTestScreen';

  @override
  _OCRTestScreenState createState() => _OCRTestScreenState();
}

class _OCRTestScreenState extends State<OCRTestScreen> {
  File _image;
  String _text;

  Future getImage() async {
    // TODO: replace deprecated pickImage
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future analyse() async {
    var visionImage = FirebaseVisionImage.fromFile(_image);
    var textRecognizer = FirebaseVision.instance.textRecognizer();
    var visionText = await textRecognizer.processImage(visionImage);

    String text = visionText.text;
    print('Recognized text:');
    print(text);
    setState(() {
      _text = text;
    });
    // for (TextBlock block in visionText.blocks) {
    //   print(block.text);
    // final Rect boundingBox = block.boundingBox;
    // final List<Offset> cornerPoints = block.cornerPoints;
    // final String text = block.text;
    // final List<RecognizedLanguage> languages = block.recognizedLanguages;

    // for (TextLine line in block.lines) {
    //   // Same getters as TextBlock
    //   for (TextElement element in line.elements) {
    //     // Same getters as TextBlock
    //   }
    // }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR'),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: getImage,
                child: Icon(Icons.add_a_photo),
              ),
              RaisedButton(
                onPressed: analyse,
                child: Icon(Icons.transform),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints.expand(
              height: 250.0,
            ),
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
            decoration: _image != null
                ? BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_image),
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
          ),
          Wrap(
            children: <Widget>[
              _text != null ? Text(_text) : Container(),
            ],
          )
        ],
      ),
    );
  }
}
