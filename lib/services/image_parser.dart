import 'dart:io';
import 'dart:math';
import 'package:cookly/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookly/services/flutter/service_locator.dart';
import 'package:cookly/services/unit_of_measure.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:cookly/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

abstract class ImageTextExtractor {
  Future<RecipeOverviewEditStep> processOverviewImage(File file);
  Future<RecipeIngredientEditStep> processIngredientsImage(File file);
  Future<RecipeInstructionEditStep> processInstructionsImage(File file);

  RecipeOverviewEditStep processOverviewImageFromText(VisionText text);
  RecipeIngredientEditStep processIngredientsImageFromText(VisionText text);
  RecipeInstructionEditStep processInstructionsImageFromText(VisionText text);
}

class ImageTextExtractorImpl implements ImageTextExtractor {
  List<UnitOfMeasure> uoms = sl.get<UnitOfMeasureProvider>().getAll();

  Future<VisionText> analyse(File image) async {
    var visionImage = FirebaseVisionImage.fromFile(image);
    var textRecognizer = FirebaseVision.instance.textRecognizer();
    var visionText = await textRecognizer.processImage(visionImage);
    textRecognizer.close();

    return visionText;
  }

  @override
  Future<RecipeIngredientEditStep> processIngredientsImage(File file) async {
    var text = await this.analyse(file);
    return processIngredientsImageFromText(text);
  }

  @override
  Future<RecipeInstructionEditStep> processInstructionsImage(File file) async {
    var text = await this.analyse(file);
    return processInstructionsImageFromText(text);
  }

  @override
  Future<RecipeOverviewEditStep> processOverviewImage(File file) async {
    var text = await this.analyse(file);
    return processOverviewImageFromText(text);
  }

  @override
  RecipeIngredientEditStep processIngredientsImageFromText(VisionText text) {
    var model = RecipeIngredientEditStep();

    var startIndex = 0;
    var headerBlock = text.blocks
        .firstWhere((e) => isIngredientHeader(e), orElse: () => null);
    if (headerBlock != null) {
      startIndex = text.blocks.indexOf(headerBlock) + 1;
    }

    for (var i = startIndex; i < text.blocks.length; i++) {
      var block = text.blocks[i];
      var textItems = block.text.split(",");
      for (var textItem in textItems) {
        // TODO: last ingredient is always set to 1 EL EL instead of oil...
        var ingredient = parseIngredient(textItem);
        if (ingredient != null) {
          model.addNewIngredient(ingredient);
        }
      }
    }

    return model;
  }

  @override
  RecipeInstructionEditStep processInstructionsImageFromText(VisionText text) {
    var model = RecipeInstructionEditStep();

    // indicator that the previous instruction may have ended abrupty
    bool possiblyIncompleteSentence = false;
    List<String> instructions = [];

    // a block may be only a single line (an incomplete sentence to be continued in the next line)
    for (var i = 0; i < text.blocks.length; i++) {
      var block = text.blocks[i];
      var lines = block.text.split(". ");

      // TODO: split block if it's lines is greater than a certain threshold by dot
      // TODO: block.lines corresponds to optical lines - manually check whether the line is a complete sentence and ends with dot
      for (var j = 0; j < lines.length; j++) {
        var line = lines[j];
        line = line.trimLeft();
        line = line.trimRight();
        if (possiblyIncompleteSentence) {
          var previous = instructions.last;
          instructions[instructions.length - 1] = previous + line;
        } else if (line.length > 10) {
          instructions.add(line);
        }
      }

      possiblyIncompleteSentence =
          !block.lines.last.text.trimRight().endsWith(".");
    }

    for (var line in instructions) {
      model.addInstruction(line);
    }

    return model;
  }

  @override
  RecipeOverviewEditStep processOverviewImageFromText(VisionText text) {
    var model = RecipeOverviewEditStep();

    var heights = text.blocks
        .where((e) => e.text != null && e.text.length > 0)
        .map((e) => e.boundingBox.height)
        .toList();
    var avgHeight = heights.isNotEmpty
        ? heights.reduce((a, b) => a + b) / text.blocks.length
        : 0;
    var maxHeight = heights.isNotEmpty ? heights.reduce(max) : 0;

    for (var block in text.blocks) {
      var height = block.boundingBox.height;
      var text = block.text;
      print('height: $height, text: $text');

      // recipe title: bigger size and rather short text
      if (text.length > 10 && text.length < 50 && height > avgHeight) {
        model.name = text;
        continue;
      }

      // description: rather short text and more than average height but not max height
      if (text.length > 10 &&
          text.length < 300 &&
          height > avgHeight &&
          height < maxHeight) {
        model.description = text;
        continue;
      }

      // duration: maximum 3 digit integer
      if (text.length > 1 && text.length < 3 && int.tryParse(text) is int) {
        model.duration = int.parse(text);
      }

      // servings: usually 1 digit integer
      if (text.length == 1 && int.tryParse(text) is int) {
        // this._model.servings = int.parse(text);
      }
    }

    return model;
  }

  isIngredientHeader(TextBlock e) {
    return e.text.trim().toLowerCase() == 'ingredients' ||
        e.text.trim().toLowerCase() == 'zutaten';
  }

  RecipeIngredientModel parseIngredient(String textItem) {
    // expect amount, unit and ingredient
    var words = textItem.split(" ");
    words.removeWhere((e) => e.isEmpty);

    var unit = '';
    double amount;
    String ingredient;

    var doubleExp =
        RegExp('[0-9]*[\.,]?[0-9]+', caseSensitive: false, multiLine: false);
    var doubleMatch = doubleExp.firstMatch(textItem);
    if (doubleMatch != null) {
      amount = double.parse(doubleMatch.group(0));
    }

    var nounsExp = RegExp('([A-ZÄÖÜ][\-\_]?[a-zäöü]*){1,}');
    var nounsMatch = nounsExp.firstMatch(textItem);
    if (nounsMatch != null) {
      ingredient = nounsMatch.group(0);
    }

    if (amount != null) {
      var groupContent = doubleMatch.group(0);

      // first check if uom is in same word like amount
      var unitIndex = words.indexOf(groupContent) + 1;
      if (unitIndex < words.length) {
        var word = words[unitIndex];
        if (doubleMatch.end < word.length) {
          unit = word.substring(doubleMatch.end);
          var uom =
              uoms.firstWhere((e) => e.displayName == unit, orElse: () => null);
          if (uom != null) {
            unit = uom.id;
          }
        }
      }
      if (unit != null) {
        for (var word in words) {
          var uom =
              uoms.firstWhere((e) => e.displayName == word, orElse: () => null);
          if (uom != null) {
            unit = uom.id;
            break;
          }
        }
      }
    }

    if (ingredient != null) {
      var note = MutableIngredientNote.empty();
      note.amount = amount;
      note.ingredient.name = ingredient;
      note.unitOfMeasure = unit;
      return RecipeIngredientModel.of(note);
    }

    return null;
  }
}
