import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  String category;

  @HiveField(3)
  String frequency;
  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  int streak;
  @HiveField(6)
  DateTime? lastCheckedDate;
  @HiveField(7)
  final String userId;

  HabitModel({
    required this.name,
    this.description,
    required this.category,
    required this.frequency,
    this.isCompleted = false,
    this.streak = 0,
    required this.userId,
  });
}
