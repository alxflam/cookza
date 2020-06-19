import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CookingInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Builder(
            builder: (context) {
              List<Row> instructions = [];

              for (var i = 0; i < model.instructions.length; i++) {
                instructions.add(_buildStep(
                    content: model.instructions[i].text, num: i + 1));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: instructions,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStep({int num, String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            color: Colors.grey,
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Text(num.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
          ),
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(content),
          ),
        )
      ],
    );
  }
}
