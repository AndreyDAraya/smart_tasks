import 'package:flutter_modular/flutter_modular.dart';
import 'package:smart_tasks/src/task/data/data.dart';
import 'package:smart_tasks/src/task/domain/domain.dart';
import 'package:smart_tasks/src/task/presenter/bloc/bloc.dart';

import 'presenter/presenter.dart';

class TaskModule extends Module {
  static const String route = '/task/';
  static const String name = '/task';

  @override
  void binds(Injector i) {
    i.addInstance(DatabaseTaskHelper.instance);
    i.add<AIDescriptionRepository>(AIDescriptionRepositoryImpl.new);
    i.add<TaskRepository>(TaskRepositoryImpl.new);
    i.addLazySingleton(
      TaskBloc.new,
      config: BindConfig(
        onDispose: (TaskBloc bloc) => bloc.close(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const TaskPage());
  }
}
