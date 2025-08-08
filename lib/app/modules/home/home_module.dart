import 'package:flutter/widgets.dart';
import 'package:flutter_shaders/app/modules/home/home_controller.dart';
import 'package:flutter_shaders/app/modules/home/home_view.dart';

class HomeModule extends StatefulWidget {
  const HomeModule({super.key});

  @override
  State<HomeModule> createState() => _HomeModuleState();
}

class _HomeModuleState extends State<HomeModule> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();

    controller = HomeController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(
      controller: controller,
    );
  }
}
