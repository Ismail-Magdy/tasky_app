import 'package:flutter/material.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/core/widgets/text_form_field_widget.dart';
import '../../../core/utils/app_dialog.dart';
import '../data/firebase/auth_firebase_database.dart';
import '../data/model/user_model.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _registerUser() async {
    AppDialog.showLoading(context);

    final result = await AuthFunctions.registerUser(
      user: UserModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userName: usernameController.text.trim(),
      ),
    );

    Navigator.of(context).pop();

    switch (result) {
      case Success<UserModel>():
        Navigator.of(context).pop();
        break;

      case ErrorState<UserModel>():
        AppDialog.showError(context: context, message: result.error);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 120, right: 24, left: 24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff404147),
                ),
              ),
              const SizedBox(height: 24),

              TextFormFieldWidget(
                title: 'Username',
                hintText: 'enter username...',
                controller: usernameController,
                myValidator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Username is required';
                  }
                  if (text.length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              TextFormFieldWidget(
                title: 'Email',
                hintText: 'enter email...',
                controller: emailController,
                myValidator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Email is required';
                  }
                  if (!text.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              TextFormFieldWidget(
                title: 'Password',
                hintText: 'enter password...',
                controller: passwordController,
                obscureText: true,
                isPassword: true,
                myValidator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Password is required';
                  }
                  if (text.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              TextFormFieldWidget(
                title: 'Confirm Password',
                hintText: 'enter confirm password...',
                controller: confirmPasswordController,
                obscureText: true,
                isPassword: true,
                myValidator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Confirm password is required';
                  }
                  if (text != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              MaterialButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  _registerUser();
                },
                color: const Color(0xff5F33E1),
                minWidth: double.infinity,
                height: 48,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Already have an account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Login',
              style: TextStyle(
                color: Color(0xff5F33E1),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
