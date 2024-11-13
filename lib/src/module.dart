import 'package:flutter_modular/flutter_modular.dart';

import 'task/module.dart';

class MainModule extends Module {
  @override
  List<Module> get imports => [GlobalCoreModule()];
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.module(TaskModule.name, module: TaskModule());
  }
}

class GlobalCoreModule extends Module {
  @override
  void exportedBinds(Injector i) {}
}
