// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  final SupabaseClient _supabase = Supabase.instance.client;

  //Login with email and password
  Future<AuthResponse> logInWithEmailAndPassword(
      String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //Register with email and password
  Future<AuthResponse> registerWithEmailAndPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  //logout with email and password
  Future<void> logOut() async {
    await _supabase.auth.signOut();
  }

  // check user confirmed the email or not
  Future<bool> isEmailVerified() async {
    try {
      final response = await _supabase.auth.refreshSession();
      final user = response.user;
      if (user?.emailConfirmedAt != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error checking email verification: $e");
      return false;
    }
  }

  //if delay after verfication then
  Future<bool> pollEmailVerificationStatus() async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(
          Duration(seconds: 5));
      if (await isEmailVerified()) {
        return true;
      }
    }
    return false;
  }

  //get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // get authentication Uid
  String? getCurrentUserId() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }
}
