import 'package:flutter/material.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/config/theme.dart';
import 'package:task_manger/services/auth_service.dart';
import 'package:task_manger/views/Home.dart';
import 'package:task_manger/widgets/custom_button.dart';
import 'package:task_manger/widgets/custom_text_field.dart';

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
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> handleRegister() async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" Passwords do not match")),
        );
        return;
      }

      final errorMessage = await _authService.register(
        email: emailController.text,
        password: passwordController.text,
      );

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    child: Form(
                      autovalidateMode: autovalidateMode,
                      key: formKey,
                      child: Column(
                        children: [
                          Text('Sign Up', style: AppTextStyles.appTitle),
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
                              icon: display
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                          ),
                          const SizedBox(height: 25),
                          CustomButton(txt: 'Register', onTap: handleRegister),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: AppTextStyles.small,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
