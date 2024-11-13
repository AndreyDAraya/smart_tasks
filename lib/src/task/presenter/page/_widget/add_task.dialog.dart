part of '../page.dart';

Future<(String, String)?> _showAddTaskDialog(
  BuildContext context,
  SharedPreferences prefs,
) async {
  const tutorialShownKey = 'dialog_tutorial_shown';
  final tutorialShown = prefs.getBool(tutorialShownKey) ?? false;

  return showDialog(
    context: context,
    builder: (_) {
      final titleController = TextEditingController();
      final descriptionController = TextEditingController();
      final aiButtonKey = GlobalKey();

      if (tutorialShown == false) {
        _showAITutorial(
          aiButtonKey,
          prefs,
          tutorialShownKey,
        ).show(context: context);
      }
      return BlocProvider.value(
        value: Modular.get<TaskBloc>(),
        child: Builder(builder: (context) {
          return BlocListener<TaskBloc, TaskState>(
            listenWhen: (previous, current) =>
                current.state == ReactState.iaGenerated,
            listener: (context, state) {
              if (state.iaDescription.isNotEmpty) {
                descriptionController.text = state.iaDescription;
              }
              if (state.iaTitle.isNotEmpty) {
                titleController.text = state.iaTitle;
              }
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
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
                ),
                child: _ContentDialogAdd(
                  titleController: titleController,
                  descriptionController: descriptionController,
                  aiButtonKey: aiButtonKey,
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}

class _ContentDialogAdd extends StatelessWidget {
  const _ContentDialogAdd({
    required this.titleController,
    required this.descriptionController,
    required this.aiButtonKey,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final GlobalKey<State<StatefulWidget>> aiButtonKey;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _AppbarDialog(),
            const SizedBox(height: 24),
            TextFieldWidget(
              controller: titleController,
              label: 'Title',
              hintText: 'What do you need to do?',
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: descriptionController,
              label: 'Description',
              hintText: 'Add more details about this task...',
            ),
            const SizedBox(height: 16),
            _AiButtonGenerator(
              aiButtonKey: aiButtonKey,
              titleController: titleController,
              descriptionController: descriptionController,
            ),
            const SizedBox(height: 24),
            _ActionDialog(
                titleController: titleController,
                descriptionController: descriptionController),
          ],
        ),
      ),
    );
  }
}

class _ActionDialog extends StatelessWidget {
  const _ActionDialog({
    required this.titleController,
    required this.descriptionController,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 12,
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
            onPressed: () => Modular.to.pop(),
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
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_kAccentColor, _kSecondaryColor],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: _kAccentColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                Modular.to.pop(
                  (
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Create Task',
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

class _AiButtonGenerator extends StatelessWidget {
  const _AiButtonGenerator({
    required this.aiButtonKey,
    required this.titleController,
    required this.descriptionController,
  });

  final GlobalKey<State<StatefulWidget>> aiButtonKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TaskBloc, TaskState>(
        buildWhen: (previous, current) =>
            current.state == ReactState.loading ||
            current.state == ReactState.iaGenerated ||
            current.state == ReactState.failure,
        builder: (context, state) {
          final isLoading = state.state == ReactState.loading;

          return Container(
            key: aiButtonKey,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _kAccentColor.withOpacity(0.2),
                  _kAccentColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _kAccentColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Visibility(
                visible: isLoading,
                replacement: const Icon(
                  Icons.auto_awesome,
                  color: _kAccentColor,
                ),
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_kAccentColor),
                  ),
                ),
              ),
              tooltip: 'Generate description with AI',
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(12),
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      if (titleController.text.trim().isNotEmpty) {
                        context.read<TaskBloc>().add(
                              OnGenerateDescriptionTaskEvent(
                                content:
                                    '${titleController.text.trim()} ${descriptionController.text.trim()}'
                                        .trim(),
                              ),
                            );
                      }
                    },
            ),
          );
        },
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade200,
        width: 1.0,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(12.0),
      ),
    );

    const focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: _kAccentColor,
        width: 2.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
    );
    return TextField(
      controller: controller,
      maxLines: 5,
      minLines: 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: focusedBorder,
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: _kPrimaryColor,
      ),
    );
  }
}

class _AppbarDialog extends StatelessWidget {
  const _AppbarDialog();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _kAccentColor.withOpacity(0.2),
                      _kAccentColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_task,
                  color: _kAccentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'Create New Task',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _kPrimaryColor,
                      ),
                ),
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
                Colors.grey.shade200.withOpacity(0.5),
                Colors.grey.shade100.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.grey.shade600),
            onPressed: () => Modular.to.pop(),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}
