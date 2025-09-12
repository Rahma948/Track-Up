import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/models/habit_model.dart';
import 'package:task_manger/models/task_model.dart';
import 'package:task_manger/utils/navigation.dart';
import 'package:task_manger/views/add_habit_view.dart';
import 'package:task_manger/views/add_task_view.dart';
import 'package:task_manger/widgets/custom_add_btn.dart';
import 'package:task_manger/widgets/custom_app_bar.dart';
import 'package:task_manger/widgets/day_achv.dart';
import 'package:task_manger/widgets/habit_card.dart';
import 'package:task_manger/widgets/my_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CustomAppBar(),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box<HabitModel>(habitBox).listenable(),
              builder: (context, Box<HabitModel> box, child) {
                final habits = box.values.toList();
                final total = habits.length;
                final completed = habits.where((h) => h.isCompleted).length;
                return DayAchievment(
                  icon: Icons.trending_up,
                  txt: 'Today\'s habit',
                  color: kHabitColor,
                  completed: completed,
                  total: total,
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<TaskModel>(taskBox).listenable(),
              builder: (context, Box<TaskModel> box, _) {
                final tasks = box.values.toList();
                final total = tasks.length;
                final completed = tasks.where((t) => t.isCompleted).length;
                return DayAchievment(
                  icon: Icons.task_outlined,
                  txt: 'Completed tasks',
                  color: kTaskColor,
                  completed: completed,
                  total: total,
                );
              },
            ),
          ],
        ),

        Row(
          children: [
            CustomAddButton(
              ontap: () {
                navigateTo(context, const AddHabitView());
              },
              txt: 'Add habit',
              color: const Color(0xffF9EF63).withAlpha(180),
            ),
            CustomAddButton(
              ontap: () {
                navigateTo(context, const AddTaskView());
              },
              txt: 'Add Task',
              color: const Color(0xffADE19E),
            ),
          ],
        ),
        const SizedBox(height: 20),

        ValueListenableBuilder(
          valueListenable: Hive.box<TaskModel>(taskBox).listenable(),
          builder: (context, Box<TaskModel> box, _) {
            final tasks = box.values.toList();
            return MyCard(
              txt: 'Today\'s Tasks',
              icon: Icons.access_time,
              tasks: tasks,
            );
          },
        ),

        const SizedBox(height: 20),
        ValueListenableBuilder(
          valueListenable: Hive.box<HabitModel>(habitBox).listenable(),
          builder: (context, Box<HabitModel> box, _) {
            final habits = box.values.toList();
            return HabitCard(
              txt: 'Today\'s habits',
              icon: Icons.trending_up,
              habits: habits,
            );
          },
        ),
      ],
    );
  }
}
