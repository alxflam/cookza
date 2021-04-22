import 'dart:io';

import 'package:cookza/constants.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_model.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Step getImageStep(BuildContext context) {
  return Step(
    title: Container(),
    isActive:
        Provider.of<RecipeEditModel>(context, listen: false).currentStep == 1,
    state: StepState.indexed,
    content: ChangeNotifierProvider.value(
      value:
          Provider.of<RecipeEditModel>(context, listen: false).imageStepModel,
      child: Consumer<RecipeImageEditStep>(
        builder: (context, model, child) {
          Future<void> getImage(ImageSource source) async {
            var picker = ImagePicker();
            final image = await picker.getImage(source: source);
            if (image != null) {
              model.image = File(image.path);
            } else {
              print('picked image is null');
            }
            final LostData response = await picker.getLostData();
            if (!response.isEmpty) {
              print('lost data');
            }
          }

          return Column(
            children: <Widget>[
              Container(
                child: model.image == null
                    ? SelectImageWidget(onSelect: getImage)
                    : ImageSelectedWidget(
                        image: model.image!,
                        onDelete: () => model.image = null),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class SelectImageWidget extends StatelessWidget {
  final Function onSelect;

  SelectImageWidget({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(AppLocalizations.of(context)!.addImageLong),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () {
                onSelect(ImageSource.gallery);
              },
            ),
            IconButton(
              onPressed: () {
                onSelect(ImageSource.camera);
              },
              icon: Icon(Icons.camera_alt),
            )
          ],
        ),
      ],
    );
  }
}

class ImageSelectedWidget extends StatelessWidget {
  ImageSelectedWidget({required this.image, required this.onDelete});

  final File image;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: 300.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
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
              child: Icon(Icons.delete, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
