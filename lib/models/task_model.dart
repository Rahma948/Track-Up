import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 2)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String priority;

  @HiveField(4)
  final String? endDate;

  @HiveField(5)
  bool isCompleted;
  TaskModel({
    required this.name,
    this.description,
    required this.category,
    required this.priority,
    this.endDate,
    this.isCompleted = false,
  });
}
