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

  Color _getGPAColor(double gpa) {
    if (gpa >= 3.7) return const Color(0xFF2E7D32); // Dark Green
    if (gpa >= 3.0) return const Color(0xFF1565C0); // Dark Blue
    if (gpa >= 2.3) return const Color(0xFF6A1B9A); // Purple
    if (gpa >= 2.0) return const Color(0xFFEF6C00); // Orange
    return const Color(0xFFD32F2F); // Red
  }

  @override
  Widget build(BuildContext context) {
    final List<Course> courses =
        ModalRoute.of(context)!.settings.arguments as List<Course>;
    final gpa = calculateGPA(courses);
    final gpaClass = getGPAClass(gpa);
    final gpaColor = _getGPAColor(gpa);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Result'),
        backgroundColor: gpaColor.withOpacity(0.9),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gpaColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: gpaColor.withOpacity(0.3), width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Your GPA',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        gpa.toStringAsFixed(2),
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: gpaColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: gpaColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          gpaClass,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: gpaColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Course Breakdown',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ...courses.map((course) => Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        course.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Credits: ${course.credits}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Grade: ${course.grade}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: gpaColor,
                            ),
                          ),
                          Text(
                            'Points: ${course.totalGradePoints.toStringAsFixed(2)}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gpaColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Calculate Another GPA',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
