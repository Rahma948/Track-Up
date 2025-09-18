import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const ProfileCard({
    super.key,
    required this.title,
    required this.value,
    this.color = const Color.fromARGB(255, 243, 179, 84), // لون افتراضي
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),

          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
