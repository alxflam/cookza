import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  final ImageProvider imageProvider;

  const ImageView({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: this.imageProvider,
    );
  }
}
