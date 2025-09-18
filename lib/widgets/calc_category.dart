import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/models/task_model.dart';

class CalcCategoryWidget extends StatelessWidget {
  final String currentUserId;

  const CalcCategoryWidget({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<TaskModel>(taskBox).listenable(),
      builder: (context, Box<TaskModel> box, _) {
        final task = box.values
            .where((t) => t.userId == currentUserId)
            .toList();

        Map<String, int> categoryCount = {
          "Work": 0,
          "Personal": 0,
          "Study": 0,
          "Family": 0,
          "Shopping": 0,
          "General": 0,
        };

        for (var i in task) {
          final cat = i.category;
          if (categoryCount.containsKey(cat)) {
            categoryCount[cat] = categoryCount[cat]! + 1;
          }
        }
        final noData = categoryCount.values.every((count) => count == 0);

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Tasks by category',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                if (noData) const Center(child: Text('No tasks yet!')),
                if (!noData) ...[
                  ...categoryCount.entries
                      .where((e) => e.value > 0)
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    220,
                                    218,
                                    218,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(child: Text('${e.value}')),
                              ),
                            ],
                          ),
                        ),
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
