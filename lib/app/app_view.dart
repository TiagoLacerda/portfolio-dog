import 'package:material_ui/material_ui.dart';
import 'package:portfolio_design_system/portfolio_design_system.dart';

import '../l10n/generated/modular_localization.dart';
import 'app_controller.dart';
import 'core/router/router.dart';

class AppView extends StatelessWidget {
  final AppController controller;

  const AppView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) => MaterialApp.router(
        key: ValueKey(controller.locale),
        onGenerateTitle: (context) =>
            ModularLocalization.localizations.appView.title,
        debugShowCheckedModeBanner: false,
        theme: PortfolioTheme.light,
        darkTheme: PortfolioTheme.dark,
        themeMode: controller.themeMode,
        locale: controller.locale,
        supportedLocales: controller.supportedLocales,
        localizationsDelegates: const [
          ModularLocalization.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        routerConfig: routerConfig,
      ),
    );
  }
}
