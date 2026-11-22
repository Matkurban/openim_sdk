import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String?> resolveDefaultDbPath() async {
  final Directory directory = await getApplicationSupportDirectory();
  return '${directory.path}/kurban_open_im_sdk';
}
