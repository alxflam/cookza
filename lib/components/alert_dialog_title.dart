import 'package:flutter/material.dart';

class AlertDialogTitle extends StatelessWidget {
  final String title;

  const AlertDialogTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.error,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        Text(title),
      ],
    );
  }
}
