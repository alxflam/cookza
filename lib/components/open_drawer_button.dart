import 'package:flutter/material.dart';

class OpenDrawerButton extends StatelessWidget {
  final String _buttonMsg;

  const OpenDrawerButton(this._buttonMsg);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                child: Text(_buttonMsg),
              )
            ],
          ),
        ),
      ),
    );
  }
}
