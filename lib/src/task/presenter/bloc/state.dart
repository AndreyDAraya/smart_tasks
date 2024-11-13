part of 'bloc.dart';

enum ReactState {
  initial,
  loading,
  loaded,
  failure,
  none,
  completed,
  opened,
  created,
  deleted,
  iaGenerated,
}

class TaskState extends Equatable {
  const TaskState({
    required this.state,
    required this.failure,
    required this.tasks,
    this.iaDescription = '',
    this.iaTitle = '',
  });

  final ReactState state;
  final Failure failure;

  final List<TaskDto> tasks;

  final String iaTitle;
  final String iaDescription;

  TaskState copyWith({
    ReactState? state,
    Failure? failure,
    List<TaskDto>? tasks,
    String? iaDescription,
    String? iaTitle,
  }) =>
      TaskState(
        state: state ?? ReactState.none,
        failure: failure ?? this.failure,
        tasks: tasks ?? this.tasks,
        iaDescription: iaDescription ?? this.iaDescription,
        iaTitle: iaTitle ?? this.iaTitle,
      );

  @override
  List<Object> get props => [
        state,
        failure,
        tasks,
        iaDescription,
        iaTitle,
      ];
}
