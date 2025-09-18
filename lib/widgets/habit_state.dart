import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_manger/models/habit_model.dart';

class HabitStatsCard extends StatelessWidget {
  final String currentUserId;

  const HabitStatsCard({super.key, required this.currentUserId});

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<HabitModel>("habits").listenable(),
      builder: (context, Box<HabitModel> box, _) {
        final habits = box.values
            .where((h) => h.userId == currentUserId)
            .toList();

        if (habits.isEmpty) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(16),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  "No habits to show!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
        }

        DateTime now = DateTime.now();
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));

        List<DateTime> weekDays = List.generate(
          7,
          (i) => startOfWeek.add(Duration(days: i)),
        );

        var progressBox = Hive.box("progressBox");

        final todayKey = formatDate(now);
        final totalHabits = habits.length;
        final doneCount = habits
            .where(
              (h) =>
                  h.lastCheckedDate != null &&
                  isSameDay(h.lastCheckedDate!, now),
            )
            .length;
        final double todayProgress = totalHabits == 0
            ? 0
            : (doneCount / totalHabits) * 100;

        if (now.weekday == DateTime.sunday) {
          progressBox.clear();
        }

        progressBox.put(todayKey, todayProgress);

        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Habit Completion (%)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "${value.toInt()}%",
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              final day = weekDays[value.toInt()];
                              final dayName = DateFormat('E').format(day);
                              return Text(
                                dayName,
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(7, (i) {
                        final day = weekDays[i];
                        final dayKey = formatDate(day);

                        final double progress =
                            (progressBox.get(dayKey, defaultValue: 0.0)
                                as double);

                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: progress,
                              color: progress == 100
                                  ? Colors.green
                                  : (progress > 0
                                        ? Colors.orange
                                        : Colors.grey),
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
