import 'package:authapp/Auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  //supabase setup
  await Supabase.initialize(
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2ZGJvZmdkdXhkZHRraG1tcXN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYyMjY4OTMsImV4cCI6MjA1MTgwMjg5M30.-kr39S8OVPFkqWmmwBCP-F-1ZY3OLm8V2DEtAdYhVn8",
    url: "https://hvdbofgduxddtkhmmqsv.supabase.co",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: AuthGate(),
    );
  }
}

// twilio recovery code: W173AA5FFB5B68SUC39NZWNA