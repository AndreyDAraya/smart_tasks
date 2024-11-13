part of '../page.dart';

class _FloatingAddNewtask extends StatelessWidget {
  const _FloatingAddNewtask({
    required GlobalKey<State<StatefulWidget>> addButtonKey,
  }) : _addButtonKey = addButtonKey;

  final GlobalKey<State<StatefulWidget>> _addButtonKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kAccentColor, _kSecondaryColor],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _kAccentColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        key: _addButtonKey,
        tooltip: 'Add Task',
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();

          if (!context.mounted) return;

          final canCreated = await _showAddTaskDialog(context, prefs);

          if (canCreated != null && context.mounted) {
            final (title, description) = canCreated;
            context.read<TaskBloc>().add(
                  OnCreateTaskEvent(
                    title: title,
                    description: description,
                  ),
                );
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
