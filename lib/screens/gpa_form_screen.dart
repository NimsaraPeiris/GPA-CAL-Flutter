import 'package:flutter/material.dart';
import '../models/course.dart';

// Main form widget handles GPA calculation
class GPAFormScreen extends StatefulWidget {
  const GPAFormScreen({super.key});

  @override
  State<GPAFormScreen> createState() => _GPAFormScreenState();
}

class _GPAFormScreenState extends State<GPAFormScreen> {
  // Store the list of courses for GPA calculation
  final List<Course> courses = [];
  final _formKey = GlobalKey<FormState>();

  // Controllers for course names and credits
  final List<TextEditingController> nameControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> creditControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  // Initialize all grades to 'A' by default
  final List<String> selectedGrades = List.generate(6, (index) => 'A');

  // Returns a color based on the grade to provide visual feedback
  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return const Color(0xFF2E7D32);
      case 'B+':
        return const Color(0xFF1565C0);
      case 'B':
        return const Color(0xFF1976D2);
      case 'C+':
        return const Color(0xFF6A1B9A);
      case 'C':
        return const Color(0xFF7B1FA2);
      case 'D+':
        return const Color(0xFFEF6C00);
      default:
        return const Color(0xFFD32F2F);
    }
  }

  // Validates form input
  void _calculateGPA() {
    if (_formKey.currentState!.validate()) {
      courses.clear();
      int filledCourses = 0;

      // Collect filled course information
      for (int i = 0; i < 6; i++) {
        if (nameControllers[i].text.isNotEmpty &&
            creditControllers[i].text.isNotEmpty) {
          courses.add(Course(
            name: nameControllers[i].text.trim(),
            credits: int.parse(creditControllers[i].text),
            grade: selectedGrades[i],
            gradePoints: GradeScale.gradePoints[selectedGrades[i]]!,
          ));
          filledCourses++;
        }
      }

      // Ensure at least one course entered
      if (filledCourses == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter at least one course')),
        );
        return;
      }

      // Navigate to results screen with data
      Navigator.pushNamed(
        context,
        '/result',
        arguments: courses,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Main screen with gradient background
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('GPA Calculator', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ...List.generate(6, (index) => _buildCourseInput(index)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: _calculateGPA,
                  child: const Text(
                    'Calculate GPA',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // creates individual course input card with name, credits, and grade fields
  Widget _buildCourseInput(int index) {
    final gradeColor = _getGradeColor(selectedGrades[index]);

    // Create a card for each course input
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Course ${index + 1}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameControllers[index],
              decoration: InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (index == 0 && (value == null || value.isEmpty)) {
                  return 'Please enter at least one course name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: creditControllers[index],
              decoration: InputDecoration(
                labelText: 'Credits',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (nameControllers[index].text.isNotEmpty) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter credits';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  final credits = int.parse(value);
                  if (credits <= 0) {
                    return 'Credits must be greater than 0';
                  }
                  if (credits > 20) {
                    return 'Credits cannot exceed 20';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedGrades[index],
              decoration: InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: gradeColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: gradeColor.withOpacity(0.5)),
                ),
                filled: true,
                fillColor: gradeColor.withOpacity(0.05),
              ),
              items: GradeScale.grades.map((String grade) {
                return DropdownMenuItem<String>(
                  value: grade,
                  child: Text(
                    grade,
                    style: TextStyle(
                      color: _getGradeColor(grade),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedGrades[index] = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Clean up controllers
  @override
  void dispose() {
    for (var controller in [...nameControllers, ...creditControllers]) {
      controller.dispose();
    }
    super.dispose();
  }
}
