import 'package:smart_tasks/src/task/domain/domain.dart';

class TaskDto extends ETask {
  const TaskDto({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.createdAt,
    super.completedAt,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String?;
    var status = TaskStatus.unkown;

    if (statusStr != null) {
      status = switch (statusStr) {
        'pending' => TaskStatus.pending,
        'completed' => TaskStatus.completed,
        _ => TaskStatus.unkown,
      };
    }

    return TaskDto(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      status: status,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  TaskDto copyWith({
    int? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TaskDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status.key,
        'created_at': createdAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };
}
