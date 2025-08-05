import 'dart:async';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';

abstract final class Utils {
  static Future<Image?> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return null;

    final data = result.files.single.bytes!;
    final completer = Completer<Image>();
    decodeImageFromList(data, completer.complete);
    final image = await completer.future;
    return image;
  }
}
