import 'package:flutter/material.dart';
import 'package:tasky_app/core/helpers/validator_app.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/core/utils/app_dialog.dart';
import 'package:tasky_app/core/widgets/text_form_field_widget.dart';
import 'package:tasky_app/features/auth/screens/register_screen.dart';
import '../../home/screens/home_screen.dart';
import '../data/firebase/auth_firebase_database.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  void _login() async {
    if (formKey.currentState!.validate()) {
      AppDialog.showLoading(context);

      final result = await AuthFunctions.loginUser(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.of(context).pop();

      switch (result) {
        case Success<String>():
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
          break;

        case ErrorState<String>():
          AppDialog.showError(context: context, message: result.error);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const .only(top: 120, right: 24, left: 24),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 24,
            crossAxisAlignment: .start,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: .bold,
                  color: Color(0xff404147),
                ),
              ),

              TextFormFieldWidget(
                title: 'Email',
                hintText: 'enter email...',
                controller: emailController,
                myValidator: ValidatorApp.validateEmail,
              ),

              TextFormFieldWidget(
                title: 'Password',
                hintText: 'enter password...',
                controller: passwordController,
                obscureText: true,
                isPassword: true,
                myValidator: ValidatorApp.validatePassword,
              ),

              const SizedBox(height: 24),

              MaterialButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  _login();
                },
                color: const Color(0xff5F33E1),
                minWidth: .infinity,
                height: 48,
                shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(RegisterScreen.routeName);
        },
        child: Row(
          mainAxisAlignment: .center,
          children: const [
            Text('Don’t have an account? '),
            Text(
              'Register',
              style: TextStyle(color: Color(0xff5F33E1), fontWeight: .bold),
            ),
          ],
        ),
      ),
    );
  }
}
