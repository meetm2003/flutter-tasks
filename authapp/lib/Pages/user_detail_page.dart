import 'package:authapp/Auth/auth_services.dart';
import 'package:authapp/Pages/home_page.dart';
import 'package:authapp/Services/data_services.dart';
import 'package:authapp/Widgets/custom_button.dart';
import 'package:authapp/Widgets/custom_text.dart';
import 'package:authapp/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  // get data service
  final dataServices = DataServices();

  //get auth service
  final authServices = AuthServices();

  // textControllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  // tab RegisterDetails
  void userDetails() async {
    // prepare the data
    final name = _nameController.text;
    final dob = _dobController.text;
    final phoneNumber = _phoneNoController.text;

    //attempt RegisterDetails
    try {
      await dataServices.addUser(
        name,
        dob,
        phoneNumber,
        context,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
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
                text: "Enter your details",
                type: TextType.heading,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hint: "Name",
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Date of birth",
                controller: _dobController,
                isDatePicker: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Mobile number",
                controller: _phoneNoController,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: userDetails,
                text: "Add details",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
