import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/models/habit_model.dart';

part 'add_habit_state.dart';

class AddHabitCubit extends Cubit<AddHabitState> {
  AddHabitCubit() : super(AddHabitInitial());
  void addHabit(HabitModel newHabit) async {
    emit(AddHabitLoading());

    try {
      var myBox = Hive.box<HabitModel>(habitBox);

      myBox.add(newHabit);
      emit(AddHabitSuccess());
    } catch (e) {
      emit(AddHabitFailure(error: e.toString()));
    }
  }
}
