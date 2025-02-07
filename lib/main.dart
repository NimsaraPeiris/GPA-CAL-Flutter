// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/gpa_form_screen.dart';
import 'screens/gpa_result_screen.dart';

void main() {
  runApp(const GPACalculatorApp());
}

class GPACalculatorApp extends StatelessWidget {
  const GPACalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const GPAFormScreen(),
        '/result': (context) => const GPAResultScreen(),
      },
    );
  }
}
