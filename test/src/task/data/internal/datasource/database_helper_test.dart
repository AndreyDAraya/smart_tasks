import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:smart_tasks/src/task/data/internal/datasource/database_helper.dart';
import 'package:smart_tasks/src/task/data/internal/models/task.dart';
import 'package:smart_tasks/src/task/domain/domain.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late DatabaseTaskHelper databaseHelper;
  late MockDatabase mockDatabase;

  final testTask = TaskDto(
    id: 1,
    title: 'Test Task',
    description: 'Test Description',
    status: TaskStatus.pending,
    createdAt: DateTime(2024),
  );

  final testTaskMap = {
    'id': 1,
    'title': 'Test Task',
    'description': 'Test Description',
    'status': 'pending',
    'created_at': DateTime(2024).toIso8601String(),
    'completed_at': null,
  };

  setUp(() {
    mockDatabase = MockDatabase();
    databaseHelper = DatabaseTaskHelper.instance;
    DatabaseTaskHelper.setDatabase(mockDatabase);
  });

  tearDown(() {
    DatabaseTaskHelper.setDatabase(null);
  });

  group('DatabaseTaskHelper', () {
    test('should be a singleton', () {
      final instance1 = DatabaseTaskHelper.instance;
      final instance2 = DatabaseTaskHelper.instance;
      expect(identical(instance1, instance2), true);
    });

    group('insert', () {
      test('should insert task into database', () async {
        // Arrange
        const insertedId = 1;
        when(() => mockDatabase.insert(
              DatabaseTaskHelper.table,
              testTask.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            )).thenAnswer((_) async => insertedId);

        // Act
        final result = await databaseHelper.insert(testTask);

        // Assert
        expect(result, insertedId);
        verify(() => mockDatabase.insert(
              DatabaseTaskHelper.table,
              testTask.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            )).called(1);
      });
    });

    group('getAllTasks', () {
      test('should return list of tasks from database', () async {
        // Arrange
        final taskMaps = [testTaskMap];
        when(() => mockDatabase.query(DatabaseTaskHelper.table))
            .thenAnswer((_) async => taskMaps);

        // Act
        final result = await databaseHelper.getAllTasks();

        // Assert
        expect(result.length, 1);
        expect(result.first.id, testTask.id);
        expect(result.first.title, testTask.title);
        expect(result.first.description, testTask.description);
        expect(result.first.status, testTask.status);
        expect(result.first.createdAt, testTask.createdAt);
        verify(() => mockDatabase.query(DatabaseTaskHelper.table)).called(1);
      });

      test('should return empty list when no tasks exist', () async {
        // Arrange
        when(() => mockDatabase.query(DatabaseTaskHelper.table))
            .thenAnswer((_) async => []);

        // Act
        final result = await databaseHelper.getAllTasks();

        // Assert
        expect(result.isEmpty, true);
        verify(() => mockDatabase.query(DatabaseTaskHelper.table)).called(1);
      });
    });

    group('update', () {
      test('should update task in database', () async {
        // Arrange
        const rowsAffected = 1;
        when(() => mockDatabase.update(
              DatabaseTaskHelper.table,
              testTask.toJson(),
              where: '${DatabaseTaskHelper.columnId} = ?',
              whereArgs: [testTask.id],
            )).thenAnswer((_) async => rowsAffected);

        // Act
        final result = await databaseHelper.update(testTask);

        // Assert
        expect(result, rowsAffected);
        verify(() => mockDatabase.update(
              DatabaseTaskHelper.table,
              testTask.toJson(),
              where: '${DatabaseTaskHelper.columnId} = ?',
              whereArgs: [testTask.id],
            )).called(1);
      });

      test('should return 0 when task does not exist', () async {
        // Arrange
        const rowsAffected = 0;
        when(() => mockDatabase.update(
              DatabaseTaskHelper.table,
              testTask.toJson(),
              where: '${DatabaseTaskHelper.columnId} = ?',
              whereArgs: [testTask.id],
            )).thenAnswer((_) async => rowsAffected);

        // Act
        final result = await databaseHelper.update(testTask);

        // Assert
        expect(result, 0);
        verify(() => mockDatabase.update(
              DatabaseTaskHelper.table,
              testTask.toJson(),
              where: '${DatabaseTaskHelper.columnId} = ?',
              whereArgs: [testTask.id],
            )).called(1);
      });
    });

    group('delete', () {
      test('should delete task from database', () async {
        // Arrange
        const taskId = 1;
        const rowsAffected = 1;
        when(() => mockDatabase.delete(
              DatabaseTaskHelper.table,
              where: '${DatabaseTaskHelper.columnId} = ?',
              whereArgs: [taskId],
            )).thenAnswer((_) async => rowsAffected);

        // Act
        final result = await databaseHelper.delete(taskId);

        // Assert
        expect(result, rowsAffected);
        verify(() => mockDatabase.delete(
              DatabaseTaskHelper.table,
              where: '${DatabaseTaskHelper.columnId} = ?',
              whereArgs: [taskId],
            )).called(1);
      });

      test('should return 0 when task does not exist', () async {
        // Arrange
        const taskId = 1;
        const rowsAffected = 0;
        when(() => mockDatabase.delete(
              DatabaseTaskHelper.table,
              where: '${DatabaseTaskHelper.columnId} = ?',
              whereArgs: [taskId],
            )).thenAnswer((_) async => rowsAffected);

        // Act
        final result = await databaseHelper.delete(taskId);

        // Assert
        expect(result, 0);
        verify(() => mockDatabase.delete(
              DatabaseTaskHelper.table,
              where: '${DatabaseTaskHelper.columnId} = ?',
              whereArgs: [taskId],
            )).called(1);
      });
    });
  });
}
