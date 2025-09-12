import 'package:hive/hive.dart';
import 'package:task_manger/config/constant.dart';
import '../models/task_model.dart';

class TaskService {
  final Box<TaskModel> _taskBox = Hive.box<TaskModel>(taskBox);

  Future<void> addTask(TaskModel task) async {
    await _taskBox.add(task);
  }

  List<TaskModel> getTasks() {
    return _taskBox.values.toList();
  }

  Future<void> updateTask(int index, TaskModel task) async {
    await _taskBox.putAt(index, task);
  }

  Future<void> deleteTask(int index) async {
    await _taskBox.deleteAt(index);
  }
}
