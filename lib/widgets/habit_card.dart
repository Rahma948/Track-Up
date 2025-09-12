import 'package:flutter/material.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/models/habit_model.dart';

class HabitCard extends StatefulWidget {
  const HabitCard({
    super.key,
    required this.txt,
    required this.icon,
    required this.habits,
  });

  final String txt;
  final IconData icon;
  final List<HabitModel> habits;

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.txt,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(widget.icon, color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 12),

            widget.habits.isEmpty
                ? Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'asset/images/undraw_everyday-life_5bqa-removebg-preview.png',
                          width: 200,
                          height: 90,
                        ),
                      ),
                      const Text(
                        "No habits yet!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.habits.length,
                    itemBuilder: (context, index) {
                      final habit = widget.habits[index];

                      if (habit.lastCheckedDate == null ||
                          !isSameDay(habit.lastCheckedDate!, today)) {
                        if (habit.lastCheckedDate != null &&
                            daysBetween(habit.lastCheckedDate!, today) > 1) {
                          habit.streak = 0;
                        }

                        habit.isCompleted = false;
                        habit.save();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: habit.isCompleted
                                ? Colors.green.shade50
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: habit.isCompleted
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),

                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.orange,
                                  size: 28,
                                ),
                                Text(
                                  "${habit.streak}d",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),

                            title: Text(
                              habit.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: habit.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (habit.description != null &&
                                    habit.description!.isNotEmpty)
                                  Text(
                                    habit.description!,
                                    style: TextStyle(
                                      color: habit.isCompleted
                                          ? Colors.grey
                                          : Colors.black87,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  habit.lastCheckedDate != null
                                      ? "Last check: ${habit.lastCheckedDate!.toLocal().toString().split(' ')[0]}"
                                      : "Not checked yet",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  activeColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  value: habit.isCompleted,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true &&
                                          (habit.lastCheckedDate == null ||
                                              !isSameDay(
                                                habit.lastCheckedDate!,
                                                today,
                                              ))) {
                                        habit.isCompleted = true;
                                        habit.streak += 1;
                                        habit.lastCheckedDate = today;
                                      }
                                      habit.save();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 120, 120, 120),
                                  ),
                                  onPressed: () async {
                                    await habit.delete();
                                    setState(() {
                                      widget.habits.remove(habit);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Habit deleted"),
                                        backgroundColor: Colors.redAccent,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
