import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPress;

  const RoundIconButton({required this.icon, required this.onPress, super.key});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.onSurface;

    return IconButton(
      icon: FaIcon(
        this.icon,
        size: 15,
      ),
      color: color,
      onPressed: this.onPress,
    );
  }
}
