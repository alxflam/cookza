import 'package:cookza/viewmodel/recipe_view/recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstructionsTab extends StatelessWidget {
  const InstructionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
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

  Widget _buildStep({required int num, required String content}) {
    return InstructionRow(num, content);
  }
}

class InstructionRow extends StatelessWidget {
  const InstructionRow(this.num, this.content, {Key? key}) : super(key: key);

  final int num;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LeadingStepNumber(num),
        const SizedBox(
          width: 16.0,
        ),
        InstructionText(content)
      ],
    );
  }
}

class InstructionText extends StatelessWidget {
  const InstructionText(this.content, {Key? key}) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(content),
      ),
    );
  }
}

class LeadingStepNumber extends StatelessWidget {
  const LeadingStepNumber(this.num, {Key? key}) : super(key: key);

  final int num;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.grey,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Text(num.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0)),
        ),
      ),
    );
  }
}
