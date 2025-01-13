import 'package:authapp/Auth/auth_services.dart';
import 'package:authapp/Pages/home_page.dart';
import 'package:authapp/Pages/register_page.dart';
import 'package:authapp/Widgets/custom_button.dart';
import 'package:authapp/Widgets/custom_text.dart';
import 'package:authapp/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // get auth service...
  final authService = AuthServices();

  // textControllers...
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // login button pressed...
  void login() async {
    // prepare the data...
    final email = _emailController.text;
    final password = _passwordController.text;

    // attempt login...
    try {
      await authService.logInWithEmailAndPassword(email, password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
    //catch an errors...
    catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: "Login",
                type: TextType.heading,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hint: "Email",
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Password",
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: login,
                text: "Login",
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
                child: Center(
                  child: Text("Don't have an account? Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
