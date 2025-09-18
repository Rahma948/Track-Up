import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/config/theme.dart';
import 'package:task_manger/cubits/cubit/cubit/cubit/auth_cubit.dart';
import 'package:task_manger/utils/navigation.dart';
import 'package:task_manger/views/Home.dart';
import 'package:task_manger/widgets/custom_button.dart';
import 'package:task_manger/widgets/custom_text_field.dart';
import 'package:task_manger/widgets/network_check.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool display = false;
  bool display1 = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NetworkCheck(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'asset/images/computer-user-icon-10.png',
                    width: 120,
                    height: 150,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blueGrey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 80,
                        horizontal: 15,
                      ),
                      child: BlocListener<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text("Account created successfully"),
                                ),
                              );
                            navigateTo(context, const Home());
                          } else if (state is AuthFaluire) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(content: Text(state.errorMessage)),
                              );
                          }
                        },
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return registerForm(state);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerForm(AuthState state) {
    return Form(
      autovalidateMode: autovalidateMode,
      key: formKey,
      child: Column(
        children: [
          Text('Sign Up', style: AppTextStyles.appTitle),
          const SizedBox(height: 20),
          CustomTextField(
            hint: 'Name',
            preIcon: Icons.person,
            controller: nameController,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hint: 'Email',
            preIcon: Icons.email,
            controller: emailController,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            isPassword: !display,
            hint: 'Password',
            preIcon: Icons.lock_outlined,
            controller: passwordController,
            sufIcon: IconButton(
              onPressed: () {
                setState(() {
                  display = !display;
                });
              },
              icon: display
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            isPassword: !display1,
            hint: 'Confirm Password',
            preIcon: Icons.lock_outlined,
            controller: confirmPasswordController,
            sufIcon: IconButton(
              onPressed: () {
                setState(() {
                  display1 = !display1;
                });
              },
              icon: display1
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            txt: '',
            onTap: () {
              if (formKey.currentState!.validate()) {
                if (passwordController.text.trim() !=
                    confirmPasswordController.text.trim()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match")),
                  );
                  return;
                }
                context.read<AuthCubit>().register(
                  emailController.text,
                  passwordController.text,
                  nameController.text,
                );
              } else {
                setState(() {
                  autovalidateMode = AutovalidateMode.always;
                });
              }
            },
            child: state is AuthLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account? ', style: AppTextStyles.small),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 14, color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
