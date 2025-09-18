import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/utils/build_state_card.dart';
import 'package:task_manger/views/login_view.dart';
import 'package:task_manger/models/habit_model.dart';
import 'package:task_manger/models/task_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final User? user = FirebaseAuth.instance.currentUser;
  File? myImage;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void loadImage() {
    final box = Hive.box('profileBox');
    final String? path = box.get(user?.uid);
    if (path != null) {
      setState(() {
        myImage = File(path);
      });
    }
  }

  Future<void> pickAndCropImage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return;

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit Photo',
            toolbarColor: kPrimaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            hideBottomControls: false,
          ),
          IOSUiSettings(title: 'Edit Photo', aspectRatioLockEnabled: false),
        ],
      );

      if (croppedFile == null) return;

      final File imageFile = File(croppedFile.path);

      // حفظ الصورة لكل مستخدم على حدة
      final box = Hive.box('profileBox');
      await box.put(user?.uid, imageFile.path);

      if (!mounted) return;
      setState(() {
        myImage = imageFile;
      });
    } catch (e) {
      debugPrint("Error picking/cropping image: $e");
    }
  }

  List<HabitModel> get userHabits {
    return Hive.box<HabitModel>(
      habitBox,
    ).values.where((h) => h.userId == user?.uid).toList();
  }

  List<TaskModel> get userTasks {
    return Hive.box<TaskModel>(
      taskBox,
    ).values.where((t) => t.userId == user?.uid).toList();
  }

  int get totalHabits => userHabits.length;
  int get totalTasks => userTasks.length;

  int get bestStreak {
    if (userHabits.isEmpty) return 0;
    return userHabits.map((h) => h.streak ?? 0).reduce((a, b) => a > b ? a : b);
  }

  int get level {
    if (bestStreak == 0) return 0;
    return (bestStreak ~/ 7) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: myImage != null
                          ? FileImage(myImage!)
                          : null,
                      child: myImage == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 70,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: pickAndCropImage,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: kPrimaryColor,
                          child: myImage == null
                              ? Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  user?.displayName ?? "User Name",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.email ?? "example@email.com",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 30),
                ProfileGrid(
                  totalHabits: totalHabits,
                  totalTasks: totalTasks,
                  bestStreak: bestStreak,
                  level: level,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Every 7 consecutive days = New Level',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileGrid extends StatelessWidget {
  const ProfileGrid({
    super.key,
    required this.totalHabits,
    required this.totalTasks,
    required this.bestStreak,
    required this.level,
  });

  final int totalHabits;
  final int totalTasks;
  final int bestStreak;
  final int level;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio:
          MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height / 2),
      children: [
        buildStatCard(
          icon: Icons.check_circle,
          color: Colors.blueAccent,
          title: "Habits",
          value: totalHabits.toString(),
        ),
        buildStatCard(
          icon: Icons.task_alt,
          color: Colors.green,
          title: "Tasks",
          value: totalTasks.toString(),
        ),
        buildStatCard(
          icon: Icons.local_fire_department,
          color: Colors.orange,
          title: "Best Streak",
          value: "${bestStreak}d",
        ),
        buildStatCard(
          icon: Icons.star,
          color: Colors.purple,
          title: "Level",
          value: "$level",
        ),
      ],
    );
  }
}
