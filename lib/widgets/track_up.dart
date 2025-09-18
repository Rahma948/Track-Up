import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/cubits/cubit/add_habit_cubit.dart';
import 'package:task_manger/cubits/cubit/cubit/add_task_cubit.dart';
import 'package:task_manger/cubits/cubit/cubit/cubit/auth_cubit.dart';
import 'package:task_manger/services/auth_service.dart';
import 'package:task_manger/views/Home.dart';
import 'package:task_manger/views/intro.dart';
import 'package:task_manger/views/login_view.dart';

class TrackUp extends StatelessWidget {
  const TrackUp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final myAppBox = Hive.box(appBox);
    final bool seenIntro = myAppBox.get("seenIntro", defaultValue: false);

    Widget startScreen;
    if (!seenIntro) {
      startScreen = MyIntroView();
    } else {
      if (user == null) {
        startScreen = const LoginView();
      } else {
        startScreen = const Home();
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddTaskCubit()),
        BlocProvider(create: (context) => AddHabitCubit()),
        BlocProvider(create: (context) => AuthCubit(AuthService())),
      ],
      child: MaterialApp(home: startScreen, debugShowCheckedModeBanner: false),
    );
  }
}
