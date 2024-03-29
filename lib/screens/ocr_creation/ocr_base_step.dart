import 'dart:io';

import 'package:cookza/viewmodel/ocr_creation/recipe_ocr_step.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cookza/constants.dart';

class OCRImageStep extends StatelessWidget {
  final String title;

  const OCRImageStep(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Consumer<RecipeOCRStep>(
          builder: (context, model, child) {
            Future<void> getImage(ImageSource source) async {
              var picker = ImagePicker();
              var image = await picker.pickImage(
                  source: source, imageQuality: 100, maxWidth: 1000);
              if (image != null) {
                await model.setImage(File(image.path));
              }
            }

            return Container(
              child: model.image == null
                  ? SelectImageWidget(onSelect: getImage)
                  : ImageSelectedWidget(
                      image: model.image!,
                      onDelete: () => model.setImage(null)),
            );
          },
        ),
      ),
    );
  }
}

class SelectImageWidget extends StatelessWidget {
  final Function onSelect;

  const SelectImageWidget({required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () {
                onSelect(ImageSource.gallery);
              },
            ),
            IconButton(
              onPressed: () {
                onSelect(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt),
            )
          ],
        ),
      ],
    );
  }
}

class ImageSelectedWidget extends StatelessWidget {
  const ImageSelectedWidget(
      {required this.image, required this.onDelete, super.key});

  final File image;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints.expand(
            height: 300.0,
          ),
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: ElevatedButton(
                  style: kRaisedRedButtonStyle,
                  onPressed: () {
                    this.onDelete();
                  },
                  child: const Icon(Icons.delete, color: Colors.black),
                ),
              ),
              Positioned(
                left: 0.0,
                bottom: 0.0,
                child: _getImageStateIcon(context),
              ),
            ],
          ),
        ),
        _getAcceptButton(context)
      ],
    );
  }

  Widget _getImageStateIcon(BuildContext context) {
    return Consumer<RecipeOCRStep>(
      builder: (context, model, _) {
        if (model.isPending) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          style: kRaisedGreyButtonStyle,
          onPressed: null, // not needed
          child: Builder(
            builder: (context) {
              return model.isValid
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
            },
          ),
        );
      },
    );
  }

  Widget _getAcceptButton(BuildContext context) {
    return Consumer<RecipeOCRStep>(
      builder: (context, model, _) {
        if (model.isPending || !model.isValid) {
          return Container();
        }

        return ElevatedButton(
          style: kRaisedGreenButtonStyle,
          onPressed: model.isPending || !model.isValid
              ? null
              : () {
                  // return the parsed model
                  Navigator.pop(context, model.model);
                },
          child: Text(MaterialLocalizations.of(context).continueButtonLabel),
        );
      },
    );
  }
}
