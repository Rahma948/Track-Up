import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/config/theme.dart';
import 'package:task_manger/cubits/cubit/cubit/cubit/auth_cubit.dart';
import 'package:task_manger/utils/navigation.dart';
import 'package:task_manger/views/Home.dart';
import 'package:task_manger/views/register_view.dart';
import 'package:task_manger/widgets/custom_button.dart';
import 'package:task_manger/widgets/custom_text_field.dart';
import 'package:task_manger/widgets/network_check.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool display = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                                  content: Text("Login successful"),
                                ),
                              );

                            navigateTo(context, Home());
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
                            return loginForm(state);
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

  Widget loginForm(AuthState state) {
    return Form(
      autovalidateMode: autovalidateMode,
      key: formKey,
      child: Column(
        children: [
          Text('Welcome Back!', style: AppTextStyles.appTitle),
          const SizedBox(height: 20),
          CustomTextField(
            hint: 'Enter Email',
            preIcon: Icons.email,
            controller: emailController,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hint: 'Enter your Password',
            preIcon: Icons.lock_outlined,
            isPassword: !display,
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
          const SizedBox(height: 25),
          CustomButton(
            txt: '',
            onTap: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthCubit>().logIn(
                  emailController.text,
                  passwordController.text,
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
                    'Log In',
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
              Text('don\'t have an account? ', style: AppTextStyles.small),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RegisterView();
                      },
                    ),
                  );
                },
                child: Text(
                  'Sign Up',
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
