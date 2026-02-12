import 'package:flutter/material.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/core/widgets/app_dialog.dart';
import 'package:tasky_app/core/widgets/custom_text_filed.dart';
import 'package:tasky_app/features/auth/data/firebase/auth_firebase_database.dart';
import 'package:tasky_app/features/auth/data/model/user_model.dart';
import 'package:tasky_app/features/auth/widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswwordController = TextEditingController();
  final TextEditingController _confirmPaswwordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isEyeOne = true;
  bool isEyeTwo = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const .symmetric(horizontal: 24.0, vertical: 80.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                //
                const SizedBox(height: 30),
                //
                const Text(
                  "Username",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                //
                const SizedBox(height: 8),
                //
                CustomTextField(
                  controller: _userNameController,
                  hint: "enter username...",
                ),
                //
                const SizedBox(height: 20),
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
                  hint: "enter email...",
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
                  obscureText: isEyeOne ? true : false,
                  controller: _paswwordController,
                  hint: "Password...",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isEyeOne = !isEyeOne;
                      });
                    },
                    child: isEyeOne
                        ? Icon(Icons.visibility_off_outlined)
                        : Icon(Icons.visibility_outlined),
                  ),
                ),
                //
                const SizedBox(height: 20),
                //
                const Text(
                  "Confirm Password",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                //
                const SizedBox(height: 8),
                //
                CustomTextField(
                  obscureText: isEyeTwo ? true : false,
                  controller: _confirmPaswwordController,
                  hint: "Password...",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isEyeTwo = !isEyeTwo;
                      });
                    },
                    child: isEyeTwo
                        ? Icon(Icons.visibility_off_outlined)
                        : Icon(Icons.visibility_outlined),
                  ),
                ),
                //
                const SizedBox(height: 100),
                //
                CustomButton(
                  text: "Register",
                  onPressed: () async {
                    _registerUser();
                  },
                ),
                //
                const SizedBox(height: 140),
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Login",
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

  void _registerUser() async {
    AppDialog.showLoading(context);
    final result = await AuthFunctions.registerUser(
      user: UserModel(
        email: _emailController.text,
        password: _paswwordController.text,
        userName: _userNameController.text,
      ),
    );
    Navigator.of(context).pop();
    switch (result) {
      case Success<UserModel>():
        Navigator.of(context).pop();
      case ErrorState<UserModel>():
        AppDialog.showError(context: context, message: result.error);
    }
  }
}
