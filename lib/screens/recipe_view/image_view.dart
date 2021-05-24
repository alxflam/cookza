import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  final ImageProvider imageProvider;

  const ImageView({Key? key, required this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: this.imageProvider,
      ),
    );
  }
}
