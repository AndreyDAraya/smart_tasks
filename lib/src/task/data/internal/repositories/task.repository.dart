import 'package:fpdart/fpdart.dart';
import 'package:smart_tasks/core/failure/failure.dart';
import 'package:smart_tasks/src/task/data/internal/models/task.dart';
import 'package:smart_tasks/src/task/domain/domain.dart';
import 'package:smart_tasks/core/core.dart';
import '../datasource/database_helper.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._databaseHelper);
  final DatabaseTaskHelper _databaseHelper;

  @override
  Future<Either<Failure, List<ETask>>> getTasks() async {
    try {
      final tasks = await _databaseHelper.getAllTasks();
      return Right(tasks);
    } catch (e) {
      return Left(
          Failure(code: 400, message: 'Failed to load tasks: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> createTask(ETask task) async {
    try {
      final taskDto = task as TaskDto;
      final id = await _databaseHelper.insert(taskDto);
      return Right(id);
    } catch (e) {
      return Left(Failure(
          code: 400, message: 'Failed to create task: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> updateTask(ETask task) async {
    try {
      final taskDto = task as TaskDto;
      final rowsAffected = await _databaseHelper.update(taskDto);
      if (rowsAffected == 0) {
        return const Left(Failure(code: 404, message: 'Task not found'));
      }
      return Right(rowsAffected);
    } catch (e) {
      return Left(Failure(
          code: 400, message: 'Failed to update task: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteTask(int id) async {
    try {
      final rowsAffected = await _databaseHelper.delete(id);
      if (rowsAffected == 0) {
        return const Left(Failure(code: 404, message: 'Task not found'));
      }
      return Right(rowsAffected);
    } catch (e) {
      return Left(Failure(
          code: 400, message: 'Failed to delete task: ${e.toString()}'));
    }
  }
}
