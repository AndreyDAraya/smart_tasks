import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:smart_tasks/src/module.dart';
import 'package:smart_tasks/src/task/module.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(ModularApp(module: MainModule(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(TaskModule.route);
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      title: 'Smart Task',
      routerConfig: Modular.routerConfig,
    );
  }
}
