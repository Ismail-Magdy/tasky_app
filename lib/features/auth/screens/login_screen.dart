import 'package:flutter/material.dart';
import 'package:tasky_app/core/helpers/validator_app.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/core/widgets/app_dialog.dart';
import 'package:tasky_app/core/widgets/custom_text_filed.dart';
import 'package:tasky_app/features/auth/data/firebase/auth_firebase_database.dart';
import 'package:tasky_app/features/auth/screens/register_screen.dart';
import 'package:tasky_app/features/auth/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  //
  bool isEye = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const .symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                SizedBox(height: 122),
                //
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                //
                const SizedBox(height: 55),
                //
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                //
                const SizedBox(height: 8),
                //
                CustomTextField(
                  controller: _emailController,
                  hint: "enter username...",
                  validator: Validator.validateEmail,
                ),
                //
                const SizedBox(height: 20),
                //
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                //
                const SizedBox(height: 8),
                //
                CustomTextField(
                  validator: Validator.validatePassword,
                  controller: _paswwordController,
                  hint: "Password..",
                  obscureText: isEye ? true : false,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isEye = !isEye;
                      });
                    },
                    child: isEye
                        ? Icon(Icons.visibility_off_outlined)
                        : Icon(Icons.visibility_outlined),
                  ),
                ),
                //
                const SizedBox(height: 70),
                //
                CustomButton(
                  text: "Login",
                  onPressed: () {
                    _login();
                  },
                ),
                //
                const SizedBox(height: 300),
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Color(0xFF6332E9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_key.currentState?.validate() ?? false) {
      AppDialog.showLoading(context);
      final result = await AuthFunctions.loginUser(
        email: _emailController.text,
        password: _paswwordController.text,
      );
      Navigator.of(context).pop();
      switch (result) {
        case Success<String>():
          break;
        case ErrorState<String>():
          AppDialog.showError(context: context, message: result.error);
          break;
      }
    }
  }
}
