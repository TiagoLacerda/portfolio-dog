import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/app/core/utils/utils.dart';

class HomeController extends ChangeNotifier {
  Size? size;
  Future<Image?> loadImage() async {
    try {
      final image = await Utils.pickImage();

      if (image != null) {
        size = Size(
          image.width.toDouble(),
          image.height.toDouble(),
        );
      }

      return image;
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      notifyListeners();
    }
  }
}
