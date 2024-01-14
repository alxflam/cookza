import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionText extends StatelessWidget {
  const VersionText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          var info = snapshot.data as PackageInfo;
          return Text(
            'v${info.version}',
            style: const TextStyle(fontStyle: FontStyle.italic),
          );
        }
        return Container();
      },
    );
  }
}
