import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/config/theme.dart';
import 'package:task_manger/cubits/cubit/cubit/add_task_cubit.dart';
import 'package:task_manger/models/task_model.dart';
import 'package:task_manger/widgets/custom_button.dart';
import 'package:task_manger/widgets/custom_drop_down.dart';
import 'package:task_manger/widgets/custom_text_field.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String? selectedCategory;
  String? selectedPriority;

  List<String> categories = [
    "Work",
    "Personal",
    "Study",
    "Family",
    "Shopping",
    "General",
  ];

  List<String> priorities = ["High", "Medium", "Low"];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        endDateController.text =
            "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
        title: Text('Add New Task', style: AppTextStyles.appTitleNoBold),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.task_outlined, size: 28, color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AddTaskCubit, AddTaskState>(
        listener: (context, state) {
          if (state is AddTaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is AddTaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is AddTaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return buildTaskForm();
        },
      ),
    );
  }

  Widget buildTaskForm() {
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
                // Task name
                Text('Task Name*', style: AppTextStyles.heading),
                const SizedBox(height: 8),
                CustomTextField(
                  hint: 'Task Name',
                  preIcon: Icons.edit,
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
                        categories: priorities,
                        hint: 'Priority',
                        icon: Icons.arrow_upward,
                        onChanged: (val) {
                          setState(() {
                            selectedPriority = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                Text('End Date', style: AppTextStyles.heading),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      hint: "mm/dd/yyyy",
                      preIcon: Icons.date_range,
                      controller: endDateController,
                    ),
                  ),
                ),

                // Buttons
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        txt: 'Add',
                        color: kPrimaryColor,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (selectedCategory == null ||
                                selectedPriority == null) {
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
                            BlocProvider.of<AddTaskCubit>(context).addTask(
                              TaskModel(
                                name: nameController.text,
                                category: selectedCategory!,
                                priority: selectedPriority!,
                                description: descController.text,
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
