import 'package:flutter/material.dart';

class MyLinearProgress extends StatelessWidget {
  const MyLinearProgress({
    super.key,
    required this.progressValue,
    required this.cardIcon,
    required this.cardTitle,
    required this.completed,
    required this.total,
    required this.progColor,
  });

  final double progressValue;
  final IconData cardIcon;
  final String cardTitle;
  final int completed;
  final int total;
  final Color progColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(cardIcon),
                ),

                Text(cardTitle, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completed/$total Task',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 81, 79, 79),
                  ),
                ),
                Text('${(progressValue * 100).toStringAsFixed(1)}%'),
              ],
            ),
            SizedBox(height: 5),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(20),
              value: progressValue,
              minHeight: 15,
              backgroundColor: Colors.grey,
              color: progColor,
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
