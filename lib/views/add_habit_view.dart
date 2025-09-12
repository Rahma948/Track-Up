import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/config/theme.dart';
import 'package:task_manger/cubits/cubit/add_habit_cubit.dart';
import 'package:task_manger/models/habit_model.dart';
import 'package:task_manger/widgets/custom_button.dart';
import 'package:task_manger/widgets/custom_drop_down.dart';
import 'package:task_manger/widgets/custom_text_field.dart';

class AddHabitView extends StatefulWidget {
  const AddHabitView({super.key});

  @override
  State<AddHabitView> createState() => _AddHabitViewState();
}

class _AddHabitViewState extends State<AddHabitView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String? selectedCategory;
  String? selectedFrequency;

  final List<String> categories = const [
    "Health",
    "Learning",
    "Work",
    "Sports",
    "Reading",
    "Spiritual",
    "Social",
    "General",
  ];

  final List<String> frequencies = const ["Daily", "Weekly", "Monthly"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
        title: Text('Add New Habit', style: AppTextStyles.appTitleNoBold),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.trending_up, size: 28, color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AddHabitCubit, AddHabitState>(
        listener: (context, state) {
          if (state is AddHabitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Habit added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is AddHabitFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is AddHabitLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return buildHabitForm();
        },
      ),
    );
  }

  Widget buildHabitForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Habit name
                Text('Habit Name*', style: AppTextStyles.heading),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: 'Habit Name',
                  preIcon: Icons.flag,
                  controller: nameController,
                ),

                const SizedBox(height: 20),

                // Description
                Text('Description', style: AppTextStyles.heading),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: 'Add Description (Optional)',
                  preIcon: Icons.notes,
                  controller: descController,
                  validator: (value) => null,
                ),

                const SizedBox(height: 30),

                // Dropdowns
                Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: CategoryDropdown(
                        categories: categories,
                        hint: "Category",
                        icon: Icons.category,
                        onChanged: (val) {
                          setState(() {
                            selectedCategory = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.42,
                      child: CategoryDropdown(
                        categories: frequencies,
                        hint: 'Frequency',
                        icon: Icons.repeat,
                        onChanged: (val) {
                          setState(() {
                            selectedFrequency = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Tips card
                Card(
                  color: const Color(0xFFF5F5F5),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tips for Building a Successful Habit:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("• Start with small and simple habits"),
                        Text("• Link the habit to an existing routine"),
                        Text("• Reward yourself when you achieve it"),
                        Text(
                          "• Be patient – it takes about 21 days to form a habit",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        txt: 'Add',
                        color: kPrimaryColor,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (selectedCategory == null ||
                                selectedFrequency == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please select both Category and Priority",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            BlocProvider.of<AddHabitCubit>(context).addHabit(
                              HabitModel(
                                name: nameController.text,
                                category: selectedCategory!,
                                frequency: selectedFrequency!,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        txt: 'Cancel',
                        color: const Color.fromARGB(
                          255,
                          118,
                          24,
                          24,
                        ).withAlpha(230),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
