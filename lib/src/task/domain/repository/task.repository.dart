import 'package:fpdart/fpdart.dart';
import 'package:smart_tasks/core/failure/failure.dart';
import 'package:smart_tasks/src/task/domain/domain.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<ETask>>> getTasks();
  Future<Either<Failure, int>> createTask(ETask task);
  Future<Either<Failure, int>> updateTask(ETask task);
  Future<Either<Failure, int>> deleteTask(int id);
}
