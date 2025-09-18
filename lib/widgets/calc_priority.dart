import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manger/config/constant.dart' show taskBox;
import 'package:task_manger/models/task_model.dart';

class CalcPriority extends StatelessWidget {
  final String currentUserId;

  const CalcPriority({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<TaskModel>(taskBox).listenable(),
      builder: (context, Box<TaskModel> box, _) {
        final tasks = box.values
            .where((t) => t.userId == currentUserId)
            .toList();

        final highCount = tasks.where((t) => t.priority == "High").length;
        final mediumCount = tasks.where((t) => t.priority == "Medium").length;
        final lowCount = tasks.where((t) => t.priority == "Low").length;

        final noData = highCount == 0 && mediumCount == 0 && lowCount == 0;

        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Distribute tasks according to priority',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  child: noData
                      ? const Center(
                          child: Text(
                            "There are no tasks to display.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            sections: [
                              if (highCount > 0)
                                PieChartSectionData(
                                  value: highCount.toDouble(),
                                  color: Colors.red,
                                  title: "$highCount",
                                  radius: 40,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              if (mediumCount > 0)
                                PieChartSectionData(
                                  value: mediumCount.toDouble(),
                                  color: Colors.orange,
                                  title: "$mediumCount",
                                  radius: 40,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              if (lowCount > 0)
                                PieChartSectionData(
                                  value: lowCount.toDouble(),
                                  color: Colors.green,
                                  title: "$lowCount",
                                  radius: 40,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                            centerSpaceRadius: 60,
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                if (!noData) ...[
                  if (highCount > 0)
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.red, size: 12),
                        const SizedBox(width: 4),
                        Text("High ($highCount)"),
                      ],
                    ),
                  if (mediumCount > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.orange,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text("Medium ($mediumCount)"),
                      ],
                    ),
                  if (lowCount > 0)
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.green, size: 12),
                        const SizedBox(width: 4),
                        Text("Low ($lowCount)"),
                      ],
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
