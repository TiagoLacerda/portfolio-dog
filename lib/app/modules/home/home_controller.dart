import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/app/core/utils/utils.dart';

class HomeController extends ChangeNotifier {
  Image? image;

  Future<void> loadImage() async {
    try {
      image = await Utils.pickImage();
    } catch (e) {
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
