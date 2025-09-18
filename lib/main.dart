import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/firebase_options.dart';
import 'package:task_manger/models/habit_model.dart';
import 'package:task_manger/models/task_model.dart';
import 'package:task_manger/services/notification_service.dart';
import 'package:task_manger/widgets/track_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<HabitModel>(habitBox);
  await Hive.openBox<TaskModel>(taskBox);
  await Hive.openBox(profileBox);
  await Hive.openBox(progresskBox);
  await Hive.openBox(appBox);
  await NotificationService().initNotifications();
  await NotificationService().requestPermissions();

  await NotificationService().showInstantNotification(
    'Welcome To TrackUp✨',
    'Start your journey \nimprove,and achieve more every day🚀',
  );

  runApp(const TrackUp());
}
