// lib/screens/gpa_form_screen.dart
import 'package:flutter/material.dart';
import '../models/course.dart';

class GPAFormScreen extends StatefulWidget {
  const GPAFormScreen({super.key});

  @override
  State<GPAFormScreen> createState() => _GPAFormScreenState();
}

class _GPAFormScreenState extends State<GPAFormScreen> {
  final List<Course> courses = [];
  final _formKey = GlobalKey<FormState>();
  
  final List<TextEditingController> nameControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> creditControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<String> selectedGrades = List.generate(6, (index) => 'A');

  void _calculateGPA() {
    if (_formKey.currentState!.validate()) {
      courses.clear();
      int filledCourses = 0;
      
      for (int i = 0; i < 6; i++) {
        if (nameControllers[i].text.isNotEmpty && creditControllers[i].text.isNotEmpty) {
          courses.add(Course(
            name: nameControllers[i].text.trim(),
            credits: int.parse(creditControllers[i].text),
            grade: selectedGrades[i],
            gradePoints: GradeScale.gradePoints[selectedGrades[i]]!,
          ));
          filledCourses++;
        }
      }

      if (filledCourses == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter at least one course')),
        );
        return;
      }
      
      Navigator.pushNamed(
        context,
        '/result',
        arguments: courses,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ...List.generate(6, (index) => _buildCourseInput(index)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateGPA,
              child: const Text('Calculate GPA'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseInput(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: nameControllers[index],
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (index == 0 && (value == null || value.isEmpty)) {
                  return 'Please enter at least one course name';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: creditControllers[index],
              decoration: const InputDecoration(
                labelText: 'Credits',
                border: OutlineInputBorder(),
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
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedGrades[index],
              decoration: const InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(),
              ),
              items: GradeScale.grades.map((String grade) {
                return DropdownMenuItem<String>(
                  value: grade,
                  child: Text(grade),
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

  @override
  void dispose() {
    for (var controller in [...nameControllers, ...creditControllers]) {
      controller.dispose();
    }
    super.dispose();
  }
}
