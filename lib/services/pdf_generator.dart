import 'package:cookza/constants.dart';
import 'package:cookza/services/abstract/pdf_generator.dart';
import 'package:cookza/services/flutter/navigator_service.dart';
import 'package:cookza/services/recipe/image_manager.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFGeneratorImpl implements PDFGenerator {
  List<List<String>> _getIngredientList(RecipeViewModel recipe) {
    List<List<String>> result = [];
    var context = sl.get<NavigatorService>().currentContext;

    result.add([
      AppLocalizations.of(context)!.amount,
      AppLocalizations.of(context)!.unit,
      AppLocalizations.of(context)!.ingredient(1)
    ]);

    for (var ingredient in recipe.ingredients) {
      result.add([
        kFormatAmount(ingredient.amount),
        ingredient.uomDisplayText,
        ingredient.name
      ]);
    }

    return result;
  }

  List<pw.Bullet> _getInstructions(RecipeViewModel recipe) {
    List<pw.Bullet> result = [];
    for (var instruction in recipe.instructions) {
      result.add(pw.Bullet(text: instruction.text));
    }
    return result;
  }

  @override
  Future<pw.Document> generatePDF(List<RecipeViewModel> recipes) async {
    final doc = pw.Document();
    var buildContext = sl.get<NavigatorService>().currentContext;

    for (var recipeViewModel in recipes) {
      var imageFile = await sl
          .get<ImageManager>()
          .getRecipeImageFile(recipeViewModel.recipe);

      PdfImage? recipeImage;
      if (imageFile != null) {
        recipeImage = PdfImage.file(
          doc.document,
          bytes: imageFile.readAsBytesSync(),
        );
      }

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.letter
              .copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          header: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5),
                ),
              ),
              child: pw.Text(
                recipeViewModel.name,
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey),
              ),
            );
          },
          footer: (pw.Context context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                '${context.pageNumber}/${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey),
              ),
            );
          },
          build: (pw.Context context) => <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text(recipeViewModel.name, textScaleFactor: 2),
                ],
              ),
            ),
            // add recipe image if exists
            recipeImage != null
                ? pw.Center(
                    child: pw.ClipRRect(
                      horizontalRadius: 10,
                      verticalRadius: 10,
                      child: pw.Container(
                        width: 600,
                        height: 200,
                        child: pw.Image(
                          pw.ImageProxy(recipeImage),
                        ),
                      ),
                    ),
                  )
                : pw.Container(),
            pw.Paragraph(text: recipeViewModel.description),
            pw.Header(
                level: 1,
                text: AppLocalizations.of(buildContext)!.ingredient(2)),
            pw.Table.fromTextArray(
              context: context,
              border: pw.TableBorder(),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              data: _getIngredientList(recipeViewModel),
            ),
            pw.Header(
                level: 1,
                text: AppLocalizations.of(buildContext)!.instructions),
            pw.Column(
              children: _getInstructions(recipeViewModel),
            ),
          ],
        ),
      );
    }

    return doc;
  }
}
