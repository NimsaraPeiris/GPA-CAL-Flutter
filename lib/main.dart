// Main entry point for app
import 'package:flutter/material.dart';
import 'screens/gpa_form_screen.dart';
import 'screens/gpa_result_screen.dart';

// Launch the app
void main() {
  runApp(const GPACalculatorApp());
}

//configures the app theme and routing
class GPACalculatorApp extends StatelessWidget {
  const GPACalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      // Configure the app-wide theme with Material 3 design
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Set up the navigation routes
      initialRoute: '/',
      routes: {
        '/': (context) => const GPAFormScreen(), // Home screen
        '/result': (context) =>
            const GPAResultScreen(), // Results screen
      },
    );
  }
}
