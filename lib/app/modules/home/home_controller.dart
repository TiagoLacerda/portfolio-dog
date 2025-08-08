import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_shaders/app/core/utils/utils.dart';

class HomeController extends ChangeNotifier {
  FragmentProgram? blur;
  FragmentProgram? dog;
  Image? image;

  HomeController() {
    FragmentProgram.fromAsset('lib/shaders/gaussian_blur.frag').then((value) {
      blur = value;
      notifyListeners();
    });

    FragmentProgram.fromAsset('lib/shaders/dog.frag').then((value) {
      dog = value;
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
