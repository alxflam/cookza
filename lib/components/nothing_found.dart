import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NothingFound extends StatelessWidget {
  final String _text;

  NothingFound(this._text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: FaIcon(
              FontAwesomeIcons.search,
              size: 60,
            ),
          ),
          Text(_text),
        ],
      ),
    );
  }
}
