import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/config/theme.dart';
import 'package:task_manger/views/login_view.dart';

class MyIntroView extends StatefulWidget {
  const MyIntroView({super.key});

  @override
  State<MyIntroView> createState() => _MyIntroViewState();
}

class _MyIntroViewState extends State<MyIntroView> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
      var myAppBox = Hive.box(appBox);
      await myAppBox.put("seenIntro", true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('asset/images/welcome.png', width: 200, height: 200),
              const SizedBox(height: 18),

              Text(
                'Track Up',
                style: AppTextStyles.appTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Organize your tasks & build better habits',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
