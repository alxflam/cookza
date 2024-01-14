import 'package:flutter/material.dart';

class FutureProgressDialog extends StatelessWidget {
  final Future _future;

  const FutureProgressDialog(this._future, {super.key});

  @override
  Widget build(BuildContext context) {
    this._future.then((value) {
      Navigator.of(context).pop(value);
    }).catchError((error) {
      Navigator.of(context).pop(error);
    });

    return const Column(
      children: [CircularProgressIndicator()],
    );
  }
}
