import 'package:cookly/components/padded_qr_code.dart';
import 'package:cookly/services/firebase_provider.dart';
import 'package:cookly/services/service_locator.dart';
import 'package:flutter/material.dart';

class ShareAccountScreen extends StatelessWidget {
  static final String id = 'shareAccount';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Account'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaddedQRCode(sl.get<FirebaseProvider>().userUid, 400, 400)
          ],
        ),
      ),
    );
  }
}
