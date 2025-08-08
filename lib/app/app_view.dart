import 'package:flutter/material.dart';
import 'package:flutter_shaders/app/app_controller.dart';
import 'package:flutter_shaders/app/core/theme/app_theme.dart';
import 'package:flutter_shaders/app/modules/home/home_module.dart';

class AppView extends StatelessWidget {
  final AppController controller;

  const AppView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) => MaterialApp(
        title: 'Flutter Shaders',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: HomeModule(),
      ),
    );
  }
}
