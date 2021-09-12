import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NothingFound extends StatelessWidget {
  final String _text;

  const NothingFound(this._text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
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
