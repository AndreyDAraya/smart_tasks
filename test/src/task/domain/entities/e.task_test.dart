import 'package:flutter_test/flutter_test.dart';
import 'package:smart_tasks/src/task/domain/entities/e.task.dart';

void main() {
  group('TaskStatus', () {
    test('should have correct values', () {
      expect(TaskStatus.values.length, 3);
      expect(TaskStatus.pending.key, 'pending');
      expect(TaskStatus.completed.key, 'completed');
      expect(TaskStatus.unkown.key, 'unkown');
    });
  });

  group('ETask', () {
    final now = DateTime(2024);
    final task = ETask(
      id: 1,
      title: 'Test Task',
      description: 'Test Description',
      status: TaskStatus.pending,
      createdAt: now,
    );

    test('should create task with required fields', () {
      expect(task.id, 1);
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.status, TaskStatus.pending);
      expect(task.createdAt, now);
      expect(task.completedAt, null);
    });

    test('should create task with optional completedAt', () {
      final completedTask = ETask(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.completed,
        createdAt: now,
        completedAt: now,
      );

      expect(completedTask.completedAt, now);
    });

    test('should be equal when all properties match', () {
      final task1 = ETask(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        createdAt: now,
      );

      final task2 = ETask(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        createdAt: now,
      );

      expect(task1, task2);
    });

    test('should not be equal when any property differs', () {
      final differentIdTask = ETask(
        id: 2,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        createdAt: now,
      );
      expect(task != differentIdTask, true,
          reason: 'Tasks with different ids should not be equal');

      final differentTitleTask = ETask(
        id: 1,
        title: 'Different Title',
        description: 'Test Description',
        status: TaskStatus.pending,
        createdAt: now,
      );
      expect(task != differentTitleTask, true,
          reason: 'Tasks with different titles should not be equal');

      final differentDescriptionTask = ETask(
        id: 1,
        title: 'Test Task',
        description: 'Different Description',
        status: TaskStatus.pending,
        createdAt: now,
      );
      expect(task != differentDescriptionTask, true,
          reason: 'Tasks with different descriptions should not be equal');

      final differentStatusTask = ETask(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.completed,
        createdAt: now,
      );
      expect(task != differentStatusTask, true,
          reason: 'Tasks with different statuses should not be equal');

      final differentCreatedAtTask = ETask(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        createdAt: DateTime(2023),
      );
      expect(task != differentCreatedAtTask, true,
          reason: 'Tasks with different creation dates should not be equal');

      final differentCompletedAtTask = ETask(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        createdAt: now,
        completedAt: now,
      );
      expect(task != differentCompletedAtTask, true,
          reason: 'Tasks with different completion dates should not be equal');
    });

    group('isCompleted', () {
      test('should return true when status is completed', () {
        final completedTask = ETask(
          id: 1,
          title: 'Test Task',
          description: 'Test Description',
          status: TaskStatus.completed,
          createdAt: now,
          completedAt: now,
        );

        expect(completedTask.isCompleted, true);
      });

      test('should return false when status is pending', () {
        final pendingTask = ETask(
          id: 1,
          title: 'Test Task',
          description: 'Test Description',
          status: TaskStatus.pending,
          createdAt: now,
        );

        expect(pendingTask.isCompleted, false);
      });

      test('should return false when status is unknown', () {
        final unknownTask = ETask(
          id: 1,
          title: 'Test Task',
          description: 'Test Description',
          status: TaskStatus.unkown,
          createdAt: now,
        );

        expect(unknownTask.isCompleted, false);
      });
    });
  });
}
