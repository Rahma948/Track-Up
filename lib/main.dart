import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/cubits/cubit/add_habit_cubit.dart';
import 'package:task_manger/cubits/cubit/cubit/add_task_cubit.dart';
import 'package:task_manger/firebase_options.dart';
import 'package:task_manger/models/habit_model.dart';
import 'package:task_manger/models/task_model.dart';
import 'package:task_manger/views/intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<HabitModel>(habitBox);
  await Hive.openBox<TaskModel>(taskBox);

  runApp(const TrackUp());
}

class TrackUp extends StatelessWidget {
  const TrackUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddTaskCubit()),
        BlocProvider(create: (context) => AddHabitCubit()),
      ],
      child: MaterialApp(
        home: MyIntroView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
