part of '../page.dart';

void _showDeleteConfirmation(
  BuildContext context, {
  required ETask task,
  required void Function()? onTap,
}) {
  showDialog(
    context: context,
    builder: (_) {
      var boxDecoration = BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF8F9FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      );
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: boxDecoration,
          padding: const EdgeInsets.all(24),
          child: _ContentDeleteDialog(
            task: task,
            onTap: onTap,
          ),
        ),
      );
    },
  );
}

class _ContentDeleteDialog extends StatelessWidget {
  const _ContentDeleteDialog({
    required this.task,
    required this.onTap,
  });
  final void Function()? onTap;

  final ETask task;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _IconTrash(),
        const SizedBox(height: 16),
        const _TitleDialog(),
        const SizedBox(height: 8),
        _DescriptionDialog(task: task),
        const SizedBox(height: 24),
        _ActionsDialog(onTap: onTap),
      ],
    );
  }
}

class _ActionsDialog extends StatelessWidget {
  const _ActionsDialog({
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade200.withOpacity(0.5),
                Colors.grey.shade100.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.shade400,
                Colors.red.shade300,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade300.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DescriptionDialog extends StatelessWidget {
  const _DescriptionDialog({
    required this.task,
  });

  final ETask task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Are you sure you want to delete',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '"${task.title}"?',
          style: const TextStyle(
            color: _kPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TitleDialog extends StatelessWidget {
  const _TitleDialog();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Delete Task',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: _kPrimaryColor,
          ),
    );
  }
}

class _IconTrash extends StatelessWidget {
  const _IconTrash();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade300.withOpacity(0.2),
            Colors.red.shade300.withOpacity(0.1),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.delete_outline,
        color: Colors.red.shade400,
        size: 32,
      ),
    );
  }
}
