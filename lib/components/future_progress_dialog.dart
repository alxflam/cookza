import 'package:flutter/material.dart';

class FutureProgressDialog extends StatelessWidget {
  final Future _future;

  FutureProgressDialog(this._future);

  @override
  Widget build(BuildContext context) {
    this._future.then((value) {
      Navigator.of(context).pop(value);
    }).catchError((error) {
      Navigator.of(context).pop(error);
    });

    return Column(
      children: [CircularProgressIndicator()],
    );
  }
}
