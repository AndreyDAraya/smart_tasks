import 'package:fpdart/fpdart.dart';
import 'package:smart_tasks/core/failure/failure.dart';

abstract class AIDescriptionRepository {
  /// Generates a task description using Cerebras AI Llama 3.1-8b model
  /// based on the given task title.
  ///
  /// Returns a [Result] containing either the generated description
  /// or a [Failure] if the operation fails.
  Future<Either<Failure, String>> generateDescription(String taskTitle);
}
