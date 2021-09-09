import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class PaddedQRCode extends StatelessWidget {
  final String data;
  final int width;
  final int height;
  const PaddedQRCode(this.data, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BarcodeWidget(
        barcode: Barcode.qrCode(),
        data: this.data,
        width: this.width.toDouble(),
        height: this.height.toDouble(),
        // margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}
