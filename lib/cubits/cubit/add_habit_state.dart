part of 'add_habit_cubit.dart';

sealed class AddHabitState extends Equatable {
  const AddHabitState();

  @override
  List<Object> get props => [];
}

final class AddHabitInitial extends AddHabitState {}

final class AddHabitLoading extends AddHabitState {}

final class AddHabitSuccess extends AddHabitState {}

final class AddHabitFailure extends AddHabitState {
  final String error;

  const AddHabitFailure({required this.error});
}
