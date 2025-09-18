import 'package:flutter/material.dart';
import 'package:task_manger/config/constant.dart';

import 'package:task_manger/views/charts.dart';
import 'package:task_manger/views/home_body.dart';
import 'package:task_manger/views/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int index;
  late List<Widget> views;
  @override
  void initState() {
    super.initState();
    index = 0;
    views = [HomeBody(), ChartsView(), ProfileView()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[index],

      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          index = value;
          setState(() {});
        },
        currentIndex: index,
        selectedItemColor: kPrimaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
