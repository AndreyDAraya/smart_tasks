part of 'bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}

final class OnInitialEvent extends TaskEvent {
  @override
  List<Object> get props => [];
}

final class OnToggleTaskStatusCompletedEvent extends TaskEvent {
  const OnToggleTaskStatusCompletedEvent({required this.taskId});

  final int taskId;

  @override
  List<Object> get props => [taskId];
}

final class OnToggleTaskStatusOpenEvent extends TaskEvent {
  const OnToggleTaskStatusOpenEvent({required this.taskId});

  final int taskId;

  @override
  List<Object> get props => [taskId];
}

final class OnCreateTaskEvent extends TaskEvent {
  const OnCreateTaskEvent({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object> get props => [title, description];
}

final class OnDeleteTaskEvent extends TaskEvent {
  const OnDeleteTaskEvent({required this.taskId});

  final int taskId;

  @override
  List<Object> get props => [taskId];
}

final class OnGenerateDescriptionTaskEvent extends TaskEvent {
  const OnGenerateDescriptionTaskEvent({required this.content});

  final String content;

  @override
  List<Object> get props => [content];
}
