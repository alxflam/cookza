import 'package:flutter/material.dart';

class FutureProgressDialog extends StatelessWidget {
  final Future _future;

  const FutureProgressDialog(this._future, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this._future.then((value) {
      Navigator.of(context).pop(value);
    }).catchError((error) {
      Navigator.of(context).pop(error);
    });

    return Column(
      children: const [CircularProgressIndicator()],
    );
  }
}
