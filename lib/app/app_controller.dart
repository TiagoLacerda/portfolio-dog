import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/app/core/utils/utils.dart';

class AppController extends ChangeNotifier {
  FragmentProgram? program;
  Image? image;

  AppController() {
    FragmentProgram.fromAsset('lib/shaders/shader.frag').then((value) {
      program = value;
      notifyListeners();
    });
  }

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
