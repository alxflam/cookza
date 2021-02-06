import 'package:cookza/constants.dart';
import 'package:flutter/material.dart';

class AppIconTextWidget extends StatelessWidget {
  final MainAxisAlignment alignment;
  final double size;

  const AppIconTextWidget(
      {this.alignment = MainAxisAlignment.start, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: size + 16),
          child: Image(
            image: AssetImage(kIconTransparent),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          'ookza', // will anyways never be translated
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: this.size,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
