part of '../page.dart';

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    this.onCompleted,
    this.onOpen,
  });

  final List<ETask> tasks;
  final void Function(ETask task)? onCompleted;
  final void Function(ETask task)? onOpen;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade100,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                tasks.isEmpty ? Icons.task_alt : Icons.assignment_turned_in,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tasks.isEmpty ? 'No tasks yet' : 'All tasks completed',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key('task_${task.id}'),
          direction: task.isCompleted
              ? DismissDirection.endToStart
              : DismissDirection.startToEnd,
          onDismissed: (_) =>
              task.isCompleted ? onOpen?.call(task) : onCompleted?.call(task),
          background: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: task.isCompleted
                    ? [_kPendingColor, _kPendingColor.withOpacity(0.8)]
                    : [_kCompletedColor, _kCompletedColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment:
                task.isCompleted ? Alignment.centerRight : Alignment.centerLeft,
            padding: task.isCompleted
                ? const EdgeInsets.only(right: 24)
                : const EdgeInsets.only(left: 24),
            child: Row(
              mainAxisAlignment: task.isCompleted
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  task.isCompleted ? Icons.refresh : Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  task.isCompleted ? 'Reopen' : 'Complete',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFFE1F5FE),
                  Colors.white,
                ],
                stops: [0.0, 0.3, 1.0],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => task.isCompleted
                    ? onOpen?.call(task)
                    : onCompleted?.call(task),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: task.isCompleted
                              ? const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [_kCompletedColor, Color(0xFF00E676)],
                                )
                              : null,
                          border: Border.all(
                            color: task.isCompleted
                                ? Colors.transparent
                                : const Color(0xFF3D5AFE),
                            width: 2,
                          ),
                        ),
                        child: task.isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: task.isCompleted
                                    ? Colors.grey.shade400
                                    : const Color(0xFF1A237E),
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                style: TextStyle(
                                  color: task.isCompleted
                                      ? Colors.grey.shade400
                                      : const Color(0xFF37474F),
                                  fontSize: 14,
                                  height: 1.4,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFF3D5AFE)
                                            .withOpacity(0.2),
                                        const Color(0xFF3D5AFE)
                                            .withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    task.isCompleted && task.completedAt != null
                                        ? Icons.event_available
                                        : Icons.event,
                                    size: 14,
                                    color: const Color(0xFF3D5AFE),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.isCompleted && task.completedAt != null
                                      ? 'Completed ${_formatDate(task.completedAt)}'
                                      : _formatDate(task.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF3D5AFE),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.red.shade300.withOpacity(0.2),
                              Colors.red.shade300.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red.shade300,
                          onPressed: () {
                            _showDeleteConfirmation(
                              context,
                              task: task,
                              onTap: () {
                                context
                                    .read<TaskBloc>()
                                    .add(OnDeleteTaskEvent(taskId: task.id));
                                Modular.to.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, h:mm a').format(date);
  }
}
