import 'package:flutter/material.dart';
import 'package:task_manger/models/task_model.dart';

class MyCard extends StatefulWidget {
  const MyCard({
    super.key,
    required this.txt,
    required this.icon,
    required this.tasks,
  });

  final String txt;
  final IconData icon;
  final List<TaskModel> tasks;

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.black;
      case 'Low':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.txt,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(widget.icon),
              ],
            ),
            const SizedBox(height: 12),

            widget.tasks.isEmpty
                ? Column(
                    children: [
                      Center(
                        child: Image.asset(
                          'asset/images/undraw_next-tasks_y3rm-removebg-preview.png',
                          width: 150,
                          height: 70,
                        ),
                      ),
                      Text(
                        'No tasks yet!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      final task = widget.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            color: task.isCompleted
                                ? Colors.green.shade50
                                : Colors.transparent,
                            child: ListTile(
                              leading: task.isCompleted
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.green,
                                      size: 35,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getPriorityColor(task.priority),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        task.priority,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),

                              title: Text(
                                task.isCompleted ? 'Task Done' : task.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: task.isCompleted
                                  ? null
                                  : Text(
                                      task.description ?? '',
                                      style: TextStyle(
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: task.isCompleted
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),

                              trailing: task.isCompleted
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await task.delete();
                                        setState(() {});
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Task deleted"),
                                            backgroundColor: Colors.redAccent,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: task.isCompleted,
                                          onChanged: (val) {
                                            task.isCompleted = val ?? false;
                                            setState(() {
                                              task.save();
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                              255,
                                              120,
                                              120,
                                              120,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await task.delete();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Task is deleted",
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
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
