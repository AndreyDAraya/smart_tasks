import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_tasks/core/failure/failure.dart';
import 'package:smart_tasks/src/task/data/internal/models/task.dart';
import 'package:smart_tasks/src/task/domain/domain.dart';
import 'package:smart_tasks/src/task/presenter/bloc/bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockAIDescriptionRepository extends Mock
    implements AIDescriptionRepository {}

class FakeTask extends Fake implements TaskDto {}

void main() {
  late TaskBloc bloc;
  late MockTaskRepository taskRepository;
  late MockAIDescriptionRepository aiDescriptionRepository;

  const state = TaskState(
    state: ReactState.initial,
    failure: Failure.initial(),
    tasks: [],
  );

  final testTask = TaskDto(
    id: 1,
    title: 'Test Task',
    description: 'Test Description',
    status: TaskStatus.pending,
    createdAt: DateTime(2024),
  );

  setUpAll(() {
    registerFallbackValue(FakeTask());
  });

  setUp(() {
    taskRepository = MockTaskRepository();
    aiDescriptionRepository = MockAIDescriptionRepository();
    bloc = TaskBloc(taskRepository, aiDescriptionRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be correct', () {
    expect(
      bloc.state,
      state,
    );
  });

  group('OnInitialEvent', () {
    blocTest<TaskBloc, TaskState>(
      'emits [loading, loaded] when getTasks succeeds',
      build: () {
        when(() => taskRepository.getTasks())
            .thenAnswer((_) async => Right([testTask]));
        return bloc;
      },
      act: (bloc) => bloc.add(OnInitialEvent()),
      expect: () => [
        state.copyWith(
          state: ReactState.loading,
        ),
        state.copyWith(
          state: ReactState.loaded,
          tasks: [testTask],
        ),
      ],
      verify: (_) {
        verify(() => taskRepository.getTasks()).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, failure] when getTasks fails',
      build: () {
        when(() => taskRepository.getTasks()).thenAnswer(
            (_) async => const Left(Failure(code: 400, message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(OnInitialEvent()),
      expect: () => [
        state.copyWith(
          state: ReactState.loading,
        ),
        state.copyWith(
          state: ReactState.failure,
          failure: const Failure(code: 400, message: 'Error'),
        ),
      ],
    );
  });

  group('OnToggleTaskStatusCompletedEvent', () {
    final loadedState = state.copyWith(
      state: ReactState.loaded,
      tasks: [testTask],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, completed] when task status update succeeds',
      build: () {
        when(() => taskRepository.updateTask(any()))
            .thenAnswer((_) async => const Right(1));
        return bloc;
      },
      seed: () => loadedState,
      act: (bloc) =>
          bloc.add(OnToggleTaskStatusCompletedEvent(taskId: testTask.id)),
      expect: () => [
        loadedState.copyWith(
          state: ReactState.loading,
        ),
        predicate<TaskState>((state) =>
            state.state == ReactState.completed &&
            state.tasks.length == 1 &&
            state.tasks.first.status == TaskStatus.completed &&
            state.tasks.first.completedAt != null),
      ],
      verify: (_) {
        verify(() => taskRepository.updateTask(any())).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, failure] when task status update fails',
      build: () {
        when(() => taskRepository.updateTask(any())).thenAnswer(
            (_) async => const Left(Failure(code: 400, message: 'Error')));
        return bloc;
      },
      seed: () => loadedState,
      act: (bloc) =>
          bloc.add(OnToggleTaskStatusCompletedEvent(taskId: testTask.id)),
      expect: () => [
        loadedState.copyWith(
          state: ReactState.loading,
        ),
        loadedState.copyWith(
          state: ReactState.failure,
          failure: const Failure(code: 400, message: 'Error'),
        ),
      ],
    );
  });

  group('OnToggleTaskStatusOpenEvent', () {
    final completedTask = testTask.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime(2024),
    );
    final loadedState = state.copyWith(
      state: ReactState.loaded,
      tasks: [completedTask],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, opened] when task status update succeeds',
      build: () {
        when(() => taskRepository.updateTask(any()))
            .thenAnswer((_) async => const Right(1));
        return bloc;
      },
      seed: () => loadedState,
      act: (bloc) =>
          bloc.add(OnToggleTaskStatusOpenEvent(taskId: completedTask.id)),
      expect: () => [
        loadedState.copyWith(
          state: ReactState.loading,
        ),
        loadedState.copyWith(
          state: ReactState.opened,
          tasks: [
            completedTask.copyWith(
              status: TaskStatus.pending,
              completedAt: null,
            ),
          ],
        ),
      ],
      verify: (_) {
        verify(() => taskRepository.updateTask(any())).called(1);
      },
    );
  });

  group('OnCreateTaskEvent', () {
    blocTest<TaskBloc, TaskState>(
      'emits [loading, created] when task creation succeeds',
      build: () {
        when(() => taskRepository.createTask(any()))
            .thenAnswer((_) async => const Right(1));
        return bloc;
      },
      act: (bloc) => bloc.add(const OnCreateTaskEvent(
        title: 'New Task',
        description: 'New Description',
      )),
      expect: () => [
        state.copyWith(
          state: ReactState.loading,
        ),
        predicate<TaskState>((state) =>
            state.state == ReactState.created &&
            state.tasks.length == 1 &&
            state.tasks.first.title == 'New Task' &&
            state.tasks.first.description == 'New Description'),
      ],
      verify: (_) {
        verify(() => taskRepository.createTask(any())).called(1);
      },
    );
  });

  group('OnDeleteTaskEvent', () {
    final loadedState = state.copyWith(
      state: ReactState.loaded,
      tasks: [testTask],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, deleted] when task deletion succeeds',
      build: () {
        when(() => taskRepository.deleteTask(any()))
            .thenAnswer((_) async => const Right(1));
        return bloc;
      },
      seed: () => loadedState,
      act: (bloc) => bloc.add(OnDeleteTaskEvent(taskId: testTask.id)),
      expect: () => [
        loadedState.copyWith(
          state: ReactState.loading,
        ),
        loadedState.copyWith(
          state: ReactState.deleted,
          tasks: [],
        ),
      ],
      verify: (_) {
        verify(() => taskRepository.deleteTask(testTask.id)).called(1);
      },
    );
  });

  group('OnGenerateDescriptionTaskEvent', () {
    blocTest<TaskBloc, TaskState>(
      'emits [loading, iaGenerated] when description generation succeeds',
      build: () {
        when(() => aiDescriptionRepository.generateDescription(any()))
            .thenAnswer((_) async =>
                const Right('Generated Title|Generated Description'));
        return bloc;
      },
      act: (bloc) => bloc
          .add(const OnGenerateDescriptionTaskEvent(content: 'Test Content')),
      expect: () => [
        state.copyWith(
          state: ReactState.loading,
        ),
        state.copyWith(
          state: ReactState.iaGenerated,
          iaTitle: 'Generated Title',
          iaDescription: 'Generated Description',
        ),
      ],
      verify: (_) {
        verify(() =>
                aiDescriptionRepository.generateDescription('Test Content'))
            .called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loading, failure] when description generation fails',
      build: () {
        when(() => aiDescriptionRepository.generateDescription(any()))
            .thenAnswer(
                (_) async => const Left(Failure(code: 400, message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc
          .add(const OnGenerateDescriptionTaskEvent(content: 'Test Content')),
      expect: () => [
        state.copyWith(
          state: ReactState.loading,
        ),
        state.copyWith(
          state: ReactState.failure,
          failure: const Failure(code: 400, message: 'Error'),
        ),
      ],
    );
  });
}
