// lib/screens/gpa_result_screen.dart
import 'package:flutter/material.dart';
import '../models/course.dart';

class GPAResultScreen extends StatelessWidget {
  const GPAResultScreen({super.key});

  double calculateGPA(List<Course> courses) {
    if (courses.isEmpty) return 0.0;
    
    double totalGradePoints = 0;
    int totalCredits = 0;
    
    for (var course in courses) {
      totalGradePoints += course.totalGradePoints;
      totalCredits += course.credits;
    }
    
    return totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
  }

  String getGPAClass(double gpa) {
    if (gpa >= 3.7) return 'First Class';
    if (gpa >= 3.0) return 'Second Class Upper';
    if (gpa >= 2.3) return 'Second Class Lower';
    if (gpa >= 2.0) return 'Third Class';
    return 'Fail';
  }

  @override
  Widget build(BuildContext context) {
    final List<Course> courses = ModalRoute.of(context)!.settings.arguments as List<Course>;
    final gpa = calculateGPA(courses);
    final gpaClass = getGPAClass(gpa);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Your GPA',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gpa.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gpaClass,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Course Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...courses.map((course) => Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Text(course.name),
                subtitle: Text('Credits: ${course.credits}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Grade: ${course.grade}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Points: ${course.totalGradePoints.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Calculate Another GPA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
