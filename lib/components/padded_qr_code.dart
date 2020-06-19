import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class PaddedQRCode extends StatelessWidget {
  final String data;
  final int width;
  final int height;
  PaddedQRCode(this.data, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Card(
          child: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: this.data,
            width: this.width.toDouble(),
            height: this.height.toDouble(),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
