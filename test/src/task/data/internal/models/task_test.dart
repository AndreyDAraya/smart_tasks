import 'package:flutter_test/flutter_test.dart';
import 'package:smart_tasks/src/task/data/internal/models/task.dart';
import 'package:smart_tasks/src/task/domain/domain.dart';

void main() {
  group('TaskDto', () {
    final now = DateTime(2024);
    final task = TaskDto(
      id: 1,
      title: 'Test Task',
      description: 'Test Description',
      status: TaskStatus.pending,
      createdAt: now,
    );

    group('fromJson', () {
      test('should create TaskDto from json with all fields', () {
        final json = {
          'id': 1,
          'title': 'Test Task',
          'description': 'Test Description',
          'status': 'pending',
          'created_at': now.toIso8601String(),
          'completed_at': now.toIso8601String(),
        };

        final result = TaskDto.fromJson(json);

        expect(result.id, 1);
        expect(result.title, 'Test Task');
        expect(result.description, 'Test Description');
        expect(result.status, TaskStatus.pending);
        expect(result.createdAt, now);
        expect(result.completedAt, now);
      });

      test('should create TaskDto from json with minimal fields', () {
        final json = {
          'id': 1,
          'title': null,
          'description': null,
          'status': null,
          'created_at': null,
          'completed_at': null,
        };

        final result = TaskDto.fromJson(json);

        expect(result.id, 1);
        expect(result.title, '');
        expect(result.description, '');
        expect(result.status, TaskStatus.unkown);
        expect(result.createdAt.year, DateTime.now().year);
        expect(result.completedAt, null);
      });

      test('should parse different status values correctly', () {
        final statusTests = {
          'pending': TaskStatus.pending,
          'completed': TaskStatus.completed,
          'unknown': TaskStatus.unkown,
          'invalid': TaskStatus.unkown,
          null: TaskStatus.unkown,
        };

        for (final entry in statusTests.entries) {
          final json = {
            'id': 1,
            'title': 'Test Task',
            'description': 'Test Description',
            'status': entry.key,
            'created_at': now.toIso8601String(),
          };

          final result = TaskDto.fromJson(json);
          expect(result.status, entry.value,
              reason: 'Status "${entry.key}" should parse to ${entry.value}');
        }
      });
    });

    group('toJson', () {
      test('should convert TaskDto to json with all fields', () {
        final taskWithCompletedAt = task.copyWith(
          completedAt: now,
        );

        final result = taskWithCompletedAt.toJson();

        expect(result, {
          'id': 1,
          'title': 'Test Task',
          'description': 'Test Description',
          'status': 'pending',
          'created_at': now.toIso8601String(),
          'completed_at': now.toIso8601String(),
        });
      });

      test('should convert TaskDto to json with null completedAt', () {
        final result = task.toJson();

        expect(result, {
          'id': 1,
          'title': 'Test Task',
          'description': 'Test Description',
          'status': 'pending',
          'created_at': now.toIso8601String(),
          'completed_at': null,
        });
      });

      test('should convert different status values correctly', () {
        final statusTests = {
          TaskStatus.pending: 'pending',
          TaskStatus.completed: 'completed',
          TaskStatus.unkown: 'unkown',
        };

        for (final entry in statusTests.entries) {
          final taskWithStatus = task.copyWith(status: entry.key);
          final result = taskWithStatus.toJson();
          expect(result['status'], entry.value,
              reason: 'Status ${entry.key} should convert to "${entry.value}"');
        }
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        final newNow = DateTime(2025);
        final result = task.copyWith(
          id: 2,
          title: 'New Title',
          description: 'New Description',
          status: TaskStatus.completed,
          createdAt: newNow,
          completedAt: newNow,
        );

        expect(result.id, 2);
        expect(result.title, 'New Title');
        expect(result.description, 'New Description');
        expect(result.status, TaskStatus.completed);
        expect(result.createdAt, newNow);
        expect(result.completedAt, newNow);
      });

      test('should keep original values when not specified', () {
        final result = task.copyWith();

        expect(result.id, task.id);
        expect(result.title, task.title);
        expect(result.description, task.description);
        expect(result.status, task.status);
        expect(result.createdAt, task.createdAt);
        expect(result.completedAt, task.completedAt);
      });

      // Note: Current implementation doesn't support setting completedAt to null
      // This test documents the current behavior
      test('should keep existing completedAt when trying to set null', () {
        final taskWithCompletedAt = task.copyWith(completedAt: now);
        final result = taskWithCompletedAt.copyWith(completedAt: null);

        expect(result.completedAt, now,
            reason: 'Current implementation keeps existing completedAt value');
      });
    });
  });
}
