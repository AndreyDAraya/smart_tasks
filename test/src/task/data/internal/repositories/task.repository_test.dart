import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_tasks/src/task/data/internal/datasource/database_helper.dart';
import 'package:smart_tasks/src/task/data/internal/models/task.dart';
import 'package:smart_tasks/src/task/data/internal/repositories/task.repository.dart';
import 'package:smart_tasks/src/task/domain/domain.dart';

class MockDatabaseTaskHelper extends Mock implements DatabaseTaskHelper {}

void main() {
  late TaskRepositoryImpl repository;
  late MockDatabaseTaskHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseTaskHelper();
    repository = TaskRepositoryImpl(mockDatabaseHelper);
  });

  group('TaskRepositoryImpl', () {
    final testTask = TaskDto(
      id: 1,
      title: 'Test Task',
      description: 'Test Description',
      status: TaskStatus.pending,
      createdAt: DateTime(2024),
    );

    group('getTasks', () {
      test('should return list of tasks when successful', () async {
        // Arrange
        final tasks = [testTask];
        when(() => mockDatabaseHelper.getAllTasks())
            .thenAnswer((_) async => tasks);

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should not return left'),
          (r) {
            expect(r.length, 1);
            expect(r.first.id, testTask.id);
            expect(r.first.title, testTask.title);
            expect(r.first.description, testTask.description);
            expect(r.first.status, testTask.status);
            expect(r.first.createdAt, testTask.createdAt);
          },
        );
        verify(() => mockDatabaseHelper.getAllTasks()).called(1);
      });

      test('should return failure when database operation fails', () async {
        // Arrange
        when(() => mockDatabaseHelper.getAllTasks())
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.code, 400);
            expect(l.message, contains('Failed to load tasks'));
          },
          (r) => fail('Should not return right'),
        );
        verify(() => mockDatabaseHelper.getAllTasks()).called(1);
      });
    });

    group('createTask', () {
      test('should return task id when creation is successful', () async {
        // Arrange
        const taskId = 1;
        when(() => mockDatabaseHelper.insert(testTask))
            .thenAnswer((_) async => taskId);

        // Act
        final result = await repository.createTask(testTask);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should not return left'),
          (r) => expect(r, taskId),
        );
        verify(() => mockDatabaseHelper.insert(testTask)).called(1);
      });

      test('should return failure when creation fails', () async {
        // Arrange
        when(() => mockDatabaseHelper.insert(testTask))
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.createTask(testTask);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.code, 400);
            expect(l.message, contains('Failed to create task'));
          },
          (r) => fail('Should not return right'),
        );
        verify(() => mockDatabaseHelper.insert(testTask)).called(1);
      });
    });

    group('updateTask', () {
      test('should return rows affected when update is successful', () async {
        // Arrange
        const rowsAffected = 1;
        when(() => mockDatabaseHelper.update(testTask))
            .thenAnswer((_) async => rowsAffected);

        // Act
        final result = await repository.updateTask(testTask);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should not return left'),
          (r) => expect(r, rowsAffected),
        );
        verify(() => mockDatabaseHelper.update(testTask)).called(1);
      });

      test('should return not found failure when task does not exist',
          () async {
        // Arrange
        const rowsAffected = 0;
        when(() => mockDatabaseHelper.update(testTask))
            .thenAnswer((_) async => rowsAffected);

        // Act
        final result = await repository.updateTask(testTask);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.code, 404);
            expect(l.message, 'Task not found');
          },
          (r) => fail('Should not return right'),
        );
        verify(() => mockDatabaseHelper.update(testTask)).called(1);
      });

      test('should return failure when update fails', () async {
        // Arrange
        when(() => mockDatabaseHelper.update(testTask))
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.updateTask(testTask);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.code, 400);
            expect(l.message, contains('Failed to update task'));
          },
          (r) => fail('Should not return right'),
        );
        verify(() => mockDatabaseHelper.update(testTask)).called(1);
      });
    });

    group('deleteTask', () {
      test('should return rows affected when deletion is successful', () async {
        // Arrange
        const taskId = 1;
        const rowsAffected = 1;
        when(() => mockDatabaseHelper.delete(taskId))
            .thenAnswer((_) async => rowsAffected);

        // Act
        final result = await repository.deleteTask(taskId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should not return left'),
          (r) => expect(r, rowsAffected),
        );
        verify(() => mockDatabaseHelper.delete(taskId)).called(1);
      });

      test('should return not found failure when task does not exist',
          () async {
        // Arrange
        const taskId = 1;
        const rowsAffected = 0;
        when(() => mockDatabaseHelper.delete(taskId))
            .thenAnswer((_) async => rowsAffected);

        // Act
        final result = await repository.deleteTask(taskId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.code, 404);
            expect(l.message, 'Task not found');
          },
          (r) => fail('Should not return right'),
        );
        verify(() => mockDatabaseHelper.delete(taskId)).called(1);
      });

      test('should return failure when deletion fails', () async {
        // Arrange
        const taskId = 1;
        when(() => mockDatabaseHelper.delete(taskId))
            .thenThrow(Exception('Database error'));

        // Act
        final result = await repository.deleteTask(taskId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.code, 400);
            expect(l.message, contains('Failed to delete task'));
          },
          (r) => fail('Should not return right'),
        );
        verify(() => mockDatabaseHelper.delete(taskId)).called(1);
      });
    });
  });
}
