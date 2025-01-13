import 'package:authapp/Auth/auth_services.dart';
import 'package:authapp/Widgets/custom_button.dart';
import 'package:authapp/Widgets/custom_text.dart';
import 'package:authapp/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // get auth service...
  final authServices = AuthServices();

  // Text Controller...
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Sign Up button pressed...
  void signUp() async {
    // prepare the data...
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // check both passwords are same...
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Passwords don't match",
          ),
        ),
      );
      return;
    }

    // attempt SignUp...
    try {
      await authServices.registerWithEmailAndPassword(
        email,
        password,
      );

      // Navigate to Home page
      Navigator.pop(context);
    } catch (e) {
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
                text: "Signup",
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
              CustomTextField(
                hint: "Confirm Password",
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: signUp,
                text: "Signup",
              ),
              const SizedBox(
                height: 10,
              ),
              CustomText(
                text: "Before login unsure you have to verify your email",
                type: TextType.content,
                color: Colors.red,
              )
              // const SizedBox(height: 15),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => RegisterPage(),
              //       ),
              //     );
              //   },
              //   child: Center(
              //     child: Text("Don't have an account? Sign Up"),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
