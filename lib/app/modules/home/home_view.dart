import 'package:flutter/material.dart';
import 'package:flutter_shaders/app/modules/home/home_controller.dart';
import 'package:flutter_shaders/app/modules/home/widgets/shader_controls.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;

  const HomeView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ShaderControls(
                loadImage: controller.loadImage,
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: controller.size?.width ?? 800,
                    height: controller.size?.height ?? 600,
                    child: ColoredBox(
                      color: Colors.black,
                      child: InteractiveViewer(
                        minScale: 0.01,
                        maxScale: 100.0,
                        child: HtmlElementView(
                          viewType: 'webgl-canvas',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
