import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/app/core/utils/utils.dart';

class AppController extends ChangeNotifier {
  Image? image;
  FragmentProgram? program;

  Future<void> loadImage() async {
    try {
      image = await Utils.pickImage();
    } catch (e) {
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadShader() async {
    try {
      program = await FragmentProgram.fromAsset('lib/shaders/shader.frag');
    } catch (e) {
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
