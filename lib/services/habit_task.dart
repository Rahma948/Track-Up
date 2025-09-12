import 'package:hive/hive.dart';
import 'package:task_manger/config/constant.dart';
import '../models/habit_model.dart';

class HabitService {
  final Box<HabitModel> _habitBox = Hive.box<HabitModel>(habitBox);

  Future<void> addHabit(HabitModel habit) async {
    await _habitBox.add(habit);
  }

  List<HabitModel> getHabits() {
    return _habitBox.values.toList();
  }

  Future<void> updateHabit(int index, HabitModel habit) async {
    await _habitBox.putAt(index, habit);
  }

  Future<void> deleteHabit(int index) async {
    await _habitBox.deleteAt(index);
  }
}
