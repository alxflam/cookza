import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class VersionText extends StatelessWidget {
  const VersionText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          var info = snapshot.data as PackageInfo;
          return Text(
            'v${info.version}',
            style: TextStyle(fontStyle: FontStyle.italic),
          );
        }
        return Container();
      },
    );
  }
}