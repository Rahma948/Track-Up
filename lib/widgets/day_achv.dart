import 'package:flutter/material.dart';

class DayAchievment extends StatelessWidget {
  const DayAchievment({
    super.key,
    required this.icon,
    required this.txt,
    required this.color,
    required this.completed,
    required this.total,
  });
  final IconData icon;
  final String txt;
  final Color color;
  final int completed;
  final int total;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.44,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                Icon(icon),
                SizedBox(height: 4),
                Text(
                  txt,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('$completed\\$total'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
