import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Directory> createDirectory(String cow) async {
  final dir = Directory(
      '${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
              : await getApplicationSupportDirectory() //FOR IOS
          )!.path}/$cow');
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await dir.exists())) {
    return dir;
  } else {
    return dir.create();
  }
}
