import 'dart:async';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

abstract final class Utils {
  static Future<Image?> pickImage() async {
    final file = await FilePicker.pickFile(
      type: FileType.image,
    );

    if (file == null) return null;

    final data = await file.readAsBytes();
    final completer = Completer<Image>();
    decodeImageFromList(data, completer.complete);
    final image = await completer.future;
    return image;
  }

  static Future<Image?> loadImageFromAsset(String key) async {
    final buffer = await rootBundle.load(key);
    final list = buffer.buffer.asUint8List();
    final completer = Completer<Image>();
    decodeImageFromList(list, completer.complete);
    final image = await completer.future;
    return image;
  }
}
