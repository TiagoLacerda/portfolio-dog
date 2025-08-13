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
              ShaderControls(),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox(
                    width: 325,
                    height: 288,
                    child: InteractiveViewer(
                      child: ColoredBox(
                        color: Colors.black,
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
