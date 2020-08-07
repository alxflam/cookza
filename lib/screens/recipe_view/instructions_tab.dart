import 'package:cookly/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstructionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Builder(
            builder: (context) {
              List<Widget> instructions = [];

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
    return InstructionRow(num, content);
  }
}

class InstructionRow extends StatelessWidget {
  const InstructionRow(this.num, this.content);

  final int num;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LeadingStepNumber(num),
        SizedBox(
          width: 16.0,
        ),
        InstructionText(content)
      ],
    );
  }
}

class InstructionText extends StatelessWidget {
  const InstructionText(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(content),
      ),
    );
  }
}

class LeadingStepNumber extends StatelessWidget {
  const LeadingStepNumber(this.num);

  final int num;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
    );
  }
}
