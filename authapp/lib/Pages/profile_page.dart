import 'package:authapp/Auth/auth_services.dart';
import 'package:authapp/Pages/login_page.dart';
import 'package:authapp/Pages/user_detail_page.dart';
import 'package:authapp/Services/data_services.dart';
import 'package:authapp/Widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Get auth services...
  final authServices = AuthServices();

  // Get data services...
  final dataServices = DataServices();

  // User details
  String? currentUserId;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetail();
  }

  // Logout button pressed...
  void logout() async {
    try {
      // Clear SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Log out from Supabase
      await authServices.logOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
      debugPrint("error: $e");
    }
  }

  // fetch user details...
  void _fetchUserDetail() async {
    final String? id = authServices.getCurrentUserId();
    setState(() {
      currentUserId = id;
    });

    if (currentUserId == null) {
      debugPrint("No current user ID found.");
      return;
    }

    try {
      final fetchedUserDetails =
          await dataServices.fetchUserByAuthId(currentUserId!);

      if (fetchedUserDetails == null) {
        // Handle case where user is not found
        debugPrint(
            "User not found in database. Redirecting to UserDetailPage.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserDetailPage(),
          ),
        );
      } else {
        // Update state with fetched user details
        setState(() {
          userDetails = fetchedUserDetails;
        });
        debugPrint("User details fetched: $userDetails");

        // Store the user's ID in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userDetails!["id"]);
        await prefs.setString('userName', userDetails!["name"]);
        await prefs.setString('userDob', userDetails!["date_of_birth"]);
        await prefs.setString('userPhoneNo', userDetails!["phone_number"]);
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Error: $e"),
      //   ),
      // );
      debugPrint("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        actions: [
          Center(
            child: IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: userDetails != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Name: ${userDetails!['name'] ?? 'N/A'}",
                      type: TextType.title,
                    ),
                    CustomText(
                      text: "DOB: ${userDetails!['date_of_birth'] ?? 'N/A'}",
                      type: TextType.title,
                    ),
                    CustomText(
                      text: "Phone: ${userDetails!['phone_number'] ?? 'N/A'}",
                      type: TextType.title,
                    ),
                  ],
                )
              : CustomText(
                  text: "You have to add details first...",
                  type: TextType.heading,
                ),
        ),
      ),
    );
  }
}
