import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPress;

  RoundIconButton({this.icon, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Ink(
      // decoration: ShapeDecoration(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(50),
      //   ),
      //   color: Colors.grey,
      // ),
      child: IconButton(
        icon: FaIcon(
          this.icon,
          size: 15,
        ),
        color: Colors.white,
        onPressed: () {
          if (this.onPress != null) {
            onPress();
          }
        },
      ),
    );
  }
}
