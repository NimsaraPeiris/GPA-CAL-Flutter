// lib/models/course.dart
class Course {
  String name;
  int credits;
  String grade;
  double gradePoints;

  Course({
    required this.name,
    required this.credits,
    required this.grade,
    required this.gradePoints,
  });

  // Add the missing getter
  double get totalGradePoints => credits * gradePoints;
}

class GradeScale {
  static Map<String, double> gradePoints = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'E': 0.7,
    'F': 0.0,
  };

  static List<String> grades = gradePoints.keys.toList();
}
