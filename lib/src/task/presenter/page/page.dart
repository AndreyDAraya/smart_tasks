import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart'
    hide ModularWatchExtension;
import 'package:intl/intl.dart';
import 'package:smart_tasks/src/task/domain/entities/entities.dart';
import 'package:smart_tasks/src/task/presenter/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

part '_widget/snackbar.method.dart';
part '_widget/add_task.dialog.dart';
part '_widget/delete_task.dialog.dart';
part '_widget/tutorial.dart';
part '_widget/tutorial_ai.dart';
part '_widget/new_task.button.dart';
part '_widget/tasks.listview.dart';
part '_widget/appbar_app.dart';

// Modern color palette
const _kPrimaryColor = Color(0xFF1A237E); // Darker blue
const _kSecondaryColor = Color(0xFF3949AB); // Lighter blue
const _kAccentColor = Color(0xFF3D5AFE); // Vibrant blue
const _kBackgroundColor = Color(0xFFF8F9FF); // Light blue-tinted background
const _kCompletedColor = Color(0xFF00C853); // Vibrant green
const _kPendingColor = Color(0xFFFF6D00); // Vibrant orange

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Modular.get<TaskBloc>()..add(OnInitialEvent()),
      child: const View(),
    );
  }
}

class View extends StatefulWidget {
  const View({super.key});

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleKey = GlobalKey();
  final _tabBarKey = GlobalKey();
  final _listKey = GlobalKey();
  final _addButtonKey = GlobalKey();
  late TaskTutorial _tutorial;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tutorial = TaskTutorial([_titleKey, _tabBarKey, _listKey, _addButtonKey]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _tutorial.showTutorial(context);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.state == ReactState.completed) {
          _showSnackBar(
            context: context,
            message: 'Task completed',
            backgroundColor: _kCompletedColor,
            icon: Icons.check_circle,
          );
        }
        if (state.state == ReactState.opened) {
          _showSnackBar(
            context: context,
            message: 'Task reopened',
            backgroundColor: _kPendingColor,
            icon: Icons.refresh,
          );
        }
        if (state.state == ReactState.created) {
          _showSnackBar(
            context: context,
            message: 'Task created successfully',
            backgroundColor: _kCompletedColor,
            icon: Icons.check_circle,
          );
        }
        if (state.state == ReactState.deleted) {
          _showSnackBar(
            context: context,
            message: 'Task deleted',
            backgroundColor: Colors.red.shade400,
            icon: Icons.delete,
          );
        }
      },
      child: Scaffold(
        backgroundColor: _kBackgroundColor,
        appBar: _AppBar(
            titleKey: _titleKey,
            tabBarKey: _tabBarKey,
            tabController: _tabController),
        body: _Body(
          listKey: _listKey,
          tabController: _tabController,
        ),
        floatingActionButton: _FloatingAddNewtask(
          addButtonKey: _addButtonKey,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required GlobalKey<State<StatefulWidget>> listKey,
    required TabController tabController,
  })  : _listKey = listKey,
        _tabController = tabController;

  final GlobalKey<State<StatefulWidget>> _listKey;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state.state == ReactState.loading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_kAccentColor),
            ),
          );
        }

        if (state.state == ReactState.failure) {
          return Center(
            child: Text(
              state.failure.message,
              style: TextStyle(color: Colors.red.shade400),
            ),
          );
        }

        return Container(
          key: _listKey,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE8EAF6),
                Colors.white,
              ],
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              _TaskList(
                tasks: state.tasks.where((task) => !task.isCompleted).toList(),
                onCompleted: (task) {
                  context
                      .read<TaskBloc>()
                      .add(OnToggleTaskStatusCompletedEvent(taskId: task.id));
                },
              ),
              _TaskList(
                tasks: state.tasks.where((task) => task.isCompleted).toList(),
                onOpen: (task) {
                  context
                      .read<TaskBloc>()
                      .add(OnToggleTaskStatusOpenEvent(taskId: task.id));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
