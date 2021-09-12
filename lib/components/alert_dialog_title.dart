import 'package:flutter/material.dart';

class AlertDialogTitle extends StatelessWidget {
  final String title;

  const AlertDialogTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
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
