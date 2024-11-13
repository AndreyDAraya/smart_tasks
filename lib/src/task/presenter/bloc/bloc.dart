import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tasks/core/core.dart';
import 'package:smart_tasks/src/task/data/internal/models/task.dart';
import 'package:smart_tasks/src/task/domain/domain.dart';

part 'event.dart';
part 'state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(
    this._repository,
    this._aiDescriptionRepository,
  ) : super(
          const TaskState(
            state: ReactState.initial,
            failure: Failure.initial(),
            tasks: [],
          ),
        ) {
    on<OnInitialEvent>(_onInitialEvent);
    on<OnToggleTaskStatusCompletedEvent>(_onToggleTaskStatusCompletedEvent);
    on<OnToggleTaskStatusOpenEvent>(_onToggleTaskStatusOpenEvent);
    on<OnCreateTaskEvent>(_onCreateTaskEvent);
    on<OnDeleteTaskEvent>(_onDeleteTaskEvent);
    on<OnGenerateDescriptionTaskEvent>(_onGenerateDescriptionTaskEvent);
  }

  final TaskRepository _repository;
  final AIDescriptionRepository _aiDescriptionRepository;

  FutureOr<void> _onInitialEvent(
    OnInitialEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(state: ReactState.loading));

    final result = await _repository.getTasks();

    result.fold(
      (failure) => emit(
        state.copyWith(
          state: ReactState.failure,
          failure: failure,
        ),
      ),
      (tasks) => emit(
        state.copyWith(
          state: ReactState.loaded,
          tasks: tasks.cast<TaskDto>(),
        ),
      ),
    );
  }

  FutureOr<void> _onToggleTaskStatusCompletedEvent(
    OnToggleTaskStatusCompletedEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(state: ReactState.loading));

    final taskToUpdate =
        state.tasks.firstWhere((task) => task.id == event.taskId);
    final updatedTask = taskToUpdate.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );

    final result = await _repository.updateTask(updatedTask);

    result.fold(
      (failure) => emit(state.copyWith(
        state: ReactState.failure,
        failure: failure,
      )),
      (_) {
        final updatedTasks = state.tasks.map((task) {
          return task.id == event.taskId ? updatedTask : task;
        }).toList();

        emit(state.copyWith(
          state: ReactState.completed,
          tasks: updatedTasks,
        ));
      },
    );
  }

  FutureOr<void> _onToggleTaskStatusOpenEvent(
    OnToggleTaskStatusOpenEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(state: ReactState.loading));

    final taskToUpdate =
        state.tasks.firstWhere((task) => task.id == event.taskId);
    final updatedTask = taskToUpdate.copyWith(
      status: TaskStatus.pending,
      completedAt: null,
    );

    final result = await _repository.updateTask(updatedTask);

    result.fold(
      (failure) => emit(state.copyWith(
        state: ReactState.failure,
        failure: failure,
      )),
      (_) {
        final updatedTasks = state.tasks.map((task) {
          return task.id == event.taskId ? updatedTask : task;
        }).toList();

        emit(state.copyWith(
          state: ReactState.opened,
          tasks: updatedTasks,
        ));
      },
    );
  }

  FutureOr<void> _onCreateTaskEvent(
    OnCreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(state: ReactState.loading));

    final newTask = TaskDto(
      id: DateTime.now().millisecondsSinceEpoch,
      title: event.title,
      description: event.description,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      completedAt: null,
    );

    final result = await _repository.createTask(newTask);

    result.fold(
      (failure) => emit(state.copyWith(
        state: ReactState.failure,
        failure: failure,
      )),
      (_) {
        final updatedTasks = [...state.tasks, newTask];
        emit(state.copyWith(
          state: ReactState.created,
          tasks: updatedTasks,
        ));
      },
    );
  }

  FutureOr<void> _onDeleteTaskEvent(
    OnDeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(state: ReactState.loading));

    final result = await _repository.deleteTask(event.taskId);

    result.fold(
      (failure) => emit(state.copyWith(
        state: ReactState.failure,
        failure: failure,
      )),
      (_) {
        final updatedTasks =
            state.tasks.where((task) => task.id != event.taskId).toList();
        emit(state.copyWith(
          state: ReactState.deleted,
          tasks: updatedTasks,
        ));
      },
    );
  }

  FutureOr<void> _onGenerateDescriptionTaskEvent(
    OnGenerateDescriptionTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(state: ReactState.loading));
    final result =
        await _aiDescriptionRepository.generateDescription(event.content);
    result.fold(
      (failure) => emit(state.copyWith(
        state: ReactState.failure,
        failure: failure,
      )),
      (content) {
        final title = content.split('|')[0];
        final description = content.split('|')[1];
        emit(state.copyWith(
          state: ReactState.iaGenerated,
          iaDescription: description,
          iaTitle: title,
        ));
      },
    );
  }
}
