import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/models/task_model.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitial());
  void addTask(TaskModel newTask) async {
    try {
      emit(AddTaskLoading());
      var myBox = Hive.box<TaskModel>(taskBox);
      await myBox.add(newTask);
      emit(AddTaskSuccess());
    } catch (e) {
      emit(AddTaskFailure(error: e.toString()));
    }
  }
}
