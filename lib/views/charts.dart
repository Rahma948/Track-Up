import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/config/theme.dart';
import 'package:task_manger/models/habit_model.dart';
import 'package:task_manger/models/task_model.dart';
import 'package:task_manger/widgets/calc_category.dart';
import 'package:task_manger/widgets/calc_priority.dart';
import 'package:task_manger/widgets/day_achv.dart';
import 'package:task_manger/widgets/habit_state.dart';
import 'package:task_manger/widgets/linear_progress.dart';

class ChartsView extends StatelessWidget {
  const ChartsView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
        title: Text('Statistics', style: AppTextStyles.appTitleNoBold),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.bar_chart),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // Day achievements row
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: Hive.box<HabitModel>(habitBox).listenable(),
                builder: (context, Box<HabitModel> box, child) {
                  final habits = box.values
                      .where((h) => h.userId == currentUserId)
                      .toList();
                  final total = habits.length;
                  final completed = habits.where((h) => h.isCompleted).length;
                  return DayAchievment(
                    icon: Icons.trending_up,
                    txt: 'Completed habit',
                    color: kHabitColor,
                    completed: completed,
                    total: total,
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box<TaskModel>(taskBox).listenable(),
                builder: (context, Box<TaskModel> box, _) {
                  final tasks = box.values
                      .where((t) => t.userId == currentUserId)
                      .toList();
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

          // Task completion rate
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder(
              valueListenable: Hive.box<TaskModel>(taskBox).listenable(),
              builder: (context, Box<TaskModel> box, child) {
                final tasks = box.values
                    .where((t) => t.userId == currentUserId)
                    .toList();
                final totalTask = tasks.length;
                final completed = tasks.where((t) => t.isCompleted).length;
                double progressValue = totalTask == 0
                    ? 0
                    : completed / totalTask;
                return MyLinearProgress(
                  progressValue: progressValue,
                  cardIcon: Icons.task_outlined,
                  cardTitle: 'Task completion rate',
                  completed: completed,
                  total: totalTask,
                  progColor: const Color.fromARGB(255, 29, 79, 120),
                );
              },
            ),
          ),

          // Habit completion rate
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder(
              valueListenable: Hive.box<HabitModel>(habitBox).listenable(),
              builder: (context, Box<HabitModel> box, child) {
                final habits = box.values
                    .where((h) => h.userId == currentUserId)
                    .toList();
                final totalHabit = habits.length;
                final completed = habits.where((t) => t.isCompleted).length;
                double progressValue = totalHabit == 0
                    ? 0
                    : completed / totalHabit;
                return MyLinearProgress(
                  progressValue: progressValue,
                  cardIcon: Icons.trending_up,
                  cardTitle: 'Today\'s completed habits',
                  completed: completed,
                  total: totalHabit,
                  progColor: const Color.fromARGB(255, 250, 176, 65),
                );
              },
            ),
          ),

          // Charts
          CalcPriority(currentUserId: currentUserId),
          const SizedBox(height: 20),
          CalcCategoryWidget(currentUserId: currentUserId),
          const SizedBox(height: 20),
          HabitStatsCard(currentUserId: currentUserId),
        ],
      ),
    );
  }
}
