import 'package:equatable/equatable.dart';

enum TaskStatus {
  pending('pending'),
  completed('completed'),
  unkown('unkown');

  final String key;
  const TaskStatus(this.key);
}

class ETask extends Equatable {
  const ETask({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  bool get isCompleted => status == TaskStatus.completed;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        createdAt,
        completedAt,
      ];
}
