import 'dart:io';
import 'dart:math';
import 'package:cookza/model/entities/mutable/mutable_ingredient_note.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/services/unit_of_measure.dart';
import 'package:cookza/services/util/levenshtein.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_edit_step.dart';
import 'package:cookza/viewmodel/recipe_edit/recipe_ingredient_model.dart';
import 'package:collection/collection.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

abstract class ImageTextExtractor {
  Future<RecipeOverviewEditStep> processOverviewImage(File file);
  Future<RecipeIngredientEditStep> processIngredientsImage(File file);
  Future<RecipeInstructionEditStep> processInstructionsImage(File file,
      {String? recipeTitle, String? recipeDescription});

  RecipeOverviewEditStep processOverviewImageFromText(RecognisedText text);
  RecipeIngredientEditStep processIngredientsImageFromText(RecognisedText text);
  RecipeInstructionEditStep processInstructionsImageFromText(
      RecognisedText text,
      {String? recipeTitle,
      String? recipeDescription});
}

class ImageTextExtractorImpl implements ImageTextExtractor {
  List<UnitOfMeasure> uoms = sl.get<UnitOfMeasureProvider>().getAll();

  Future<RecognisedText> analyse(File image) async {
    var visionImage = InputImage.fromFile(image);
    var textRecognizer = GoogleMlKit.vision.textDetector();
    var visionText = await textRecognizer.processImage(visionImage);
    await textRecognizer.close();

    return visionText;
  }

  @override
  Future<RecipeIngredientEditStep> processIngredientsImage(File file) async {
    var text = await this.analyse(file);
    return processIngredientsImageFromText(text);
  }

  @override
  Future<RecipeInstructionEditStep> processInstructionsImage(File file,
      {String? recipeTitle, String? recipeDescription}) async {
    var text = await this.analyse(file);

    return processInstructionsImageFromText(text,
        recipeTitle: recipeTitle, recipeDescription: recipeDescription);
  }

  @override
  Future<RecipeOverviewEditStep> processOverviewImage(File file) async {
    var text = await this.analyse(file);
    return processOverviewImageFromText(text);
  }

  @override
  RecipeIngredientEditStep processIngredientsImageFromText(
      RecognisedText text) {
    var model = RecipeIngredientEditStep();

    var startIndex = 0;
    var headerBlock =
        text.textBlocks.firstWhereOrNull((e) => isIngredientHeader(e));
    if (headerBlock != null) {
      startIndex = text.textBlocks.indexOf(headerBlock) + 1;
    }

    for (var i = startIndex; i < text.textBlocks.length; i++) {
      var block = text.textBlocks[i];
      var textItems = block.blockText.split(',');
      for (var textItem in textItems) {
        var ingredient = parseIngredient(textItem);
        if (ingredient != null) {
          model.addNewIngredient(ingredient);
        }
      }
    }

    return model;
  }

  @override
  RecipeInstructionEditStep processInstructionsImageFromText(
      RecognisedText text,
      {String? recipeTitle,
      String? recipeDescription}) {
    var model = RecipeInstructionEditStep();
    // remove the dummy entry only added to ease editing in the dialog
    model.instructions.clear();
    // indicator that the previous instruction may have ended abrupty
    bool possiblyIncompleteSentence = false;
    List<String> instructions = [];

    // a block may be only a single line (an incomplete sentence to be continued in the next line)
    for (var i = 0; i < text.textBlocks.length; i++) {
      var block = text.textBlocks[i];
      if (block.blockText.trim().isEmpty) {
        continue;
      }

      // skip recipe name and description
      final distTitle = levenshtein(block.blockText, recipeTitle ?? '');
      final distDesc = levenshtein(block.blockText, recipeDescription ?? '');
      final maxDist = block.blockText.length / 3;
      if (distTitle < maxDist || distDesc < maxDist) {
        continue;
      }

      var lines = block.blockText.split('. ');

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
          !block.textLines.last.lineText.trimRight().endsWith('.');
    }

    for (var line in instructions) {
      model.addInstruction(line);
    }

    return model;
  }

  @override
  RecipeOverviewEditStep processOverviewImageFromText(RecognisedText text) {
    var model = RecipeOverviewEditStep();

    var heights = text.textBlocks
        .where((e) => e.blockText.isNotEmpty)
        .map((e) => e.blockRect.height)
        .toList();

    var avgHeight = heights.isNotEmpty
        ? heights.reduce((a, b) => a + b) / text.textBlocks.length
        : 0;
    var maxHeight = heights.isNotEmpty ? heights.reduce(max) : 0;

    TextBlock? recipeNameBlock;
    TextBlock? recipeDescriptionBlock;

    for (var block in text.textBlocks) {
      var height = block.blockRect.height;
      var text = block.blockText;
      var currentNameHeight = recipeNameBlock?.blockRect.height ?? 0;
      var currentDescriptionBlock =
          recipeDescriptionBlock?.blockRect.height ?? 0;
      print('height: $height, text: $text');

      // recipe title: bigger size and rather short text
      if (block.textLines.length == 1 &&
          text.length > 10 &&
          text.length < 50 &&
          height > avgHeight &&
          height > currentNameHeight) {
        recipeNameBlock = block;
        continue;
      }

      // description: rather short text in a single line (or at least two words) and more than average height but not max height
      if (block.textLines.length == 1 &&
          (text.length > 10 || text.split(' ').length > 1) &&
          text.length < 150 &&
          height > avgHeight &&
          height < maxHeight &&
          height > currentDescriptionBlock) {
        recipeDescriptionBlock = block;
        continue;
      }

      // duration: maximum 3 digit integer
      if (text.length > 1 && text.length < 3 && int.tryParse(text) is int) {
        model.duration = int.parse(text);
        continue;
      }
    }

    if (recipeNameBlock != null) {
      model.name = recipeNameBlock.blockText;
    }

    if (recipeDescriptionBlock != null) {
      model.description = recipeDescriptionBlock.blockText;
    }

    return model;
  }

  bool isIngredientHeader(TextBlock e) {
    return e.blockText.trim().toLowerCase() == 'ingredients' ||
        e.blockText.trim().toLowerCase() == 'zutaten';
  }

  RecipeIngredientModel? parseIngredient(String textItem) {
    // expect amount, unit and ingredient
    var words = textItem.split(' ');
    words.removeWhere((e) => e.isEmpty);

    String? unit = '';
    double? amount;
    String? ingredient;

    var doubleExp =
        RegExp('[0-9]*[\.,]?[0-9]+', caseSensitive: false, multiLine: false);
    var doubleMatch = doubleExp.firstMatch(textItem);
    if (doubleMatch != null) {
      amount = double.parse(doubleMatch.group(0)!);
    }

    final nounsExp = RegExp('([A-ZÄÖÜ][\-\_]?[a-zäöü]*){1,}');
    final nounsMatch = nounsExp.firstMatch(textItem);
    if (nounsMatch != null) {
      ingredient = nounsMatch.group(0)!;
    }

    if (amount != null) {
      final groupContent = doubleMatch!.group(0)!;

      // first check if uom is in same word like amount
      var unitIndex = words.indexOf(groupContent) + 1;
      if (unitIndex < words.length) {
        final word = words[unitIndex];
        if (doubleMatch.end < word.length) {
          final unitCandidate = word.substring(doubleMatch.end);
          final uom =
              uoms.firstWhereOrNull((e) => e.displayName == unitCandidate);
          if (uom != null) {
            unit = uom.id;
          }
        }
      }
      for (var word in words) {
        final uom = uoms.firstWhereOrNull((e) => e.displayName == word);
        if (uom != null) {
          unit = uom.id;
          break;
        }
      }
    }

    if (ingredient != null) {
      var note = MutableIngredientNote.empty();
      note.amount = amount ?? 1;
      note.ingredient.name = ingredient;
      note.unitOfMeasure = unit!;
      return RecipeIngredientModel.of(note);
    }

    return null;
  }
}
