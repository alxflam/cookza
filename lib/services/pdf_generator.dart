import 'package:cookly/model/view/recipe_view_model.dart';
import 'package:cookly/services/abstract/pdf_generator.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGeneratorImpl implements PdfGenerator {
  List<List<String>> _getIngredientList(RecipeViewModel recipe) {
    List<List<String>> result = [];

    for (var ingredient in recipe.ingredients) {
      result.add([
        ingredient.uomDisplayText,
        ingredient.amount.toStringAsFixed(2),
        ingredient.name
      ]);
    }

    return result;
  }

  List<pw.Bullet> _getInstructions(RecipeViewModel recipe) {
    List<pw.Bullet> result = [];
    for (var instruction in recipe.instructions) {
      result.add(pw.Bullet(text: instruction));
    }
    return result;
  }

  @override
  pw.Document generatePDF(List<RecipeViewModel> recipes) {
    final doc = pw.Document();

    for (var recipe in recipes) {
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
                border: pw.BoxBorder(
                    bottom: true, width: 0.5, color: PdfColors.grey),
              ),
              child: pw.Text(
                recipe.name,
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
                  pw.Text(recipe.name, textScaleFactor: 2),
                ],
              ),
            ),
            pw.Paragraph(text: recipe.description),
            pw.Header(level: 1, text: 'Ingredients'),
            pw.Table.fromTextArray(
              context: context,
              border: pw.TableBorder(width: 0),
              data: _getIngredientList(recipe),
            ),
            pw.Header(level: 1, text: 'Instructions'),
            pw.Column(
              children: _getInstructions(recipe),
            ),
          ],
        ),
      );
    }

    // to save as file:
    // final file = File("example.pdf");
    // await file.writeAsBytes(pdf.save());
  }
}
