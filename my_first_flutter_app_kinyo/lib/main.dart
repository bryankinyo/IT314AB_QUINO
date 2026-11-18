import 'package:flutter/material.dart';
import 'views/connection_screen.dart';
import 'views/student_list_screen.dart';
import 'views/add_student_screen.dart';
import 'views/student_details_screen.dart';
import 'views/enroll_screen.dart';
import 'views/subject_list_screen.dart';
import 'views/subject_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Enrollment System',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 44, 73, 136),
        ),
      ),

      // Naa diri ang initial route ug routes para sa navigation sa app
      // mag-start sa connection screen una para ma-test ang database
      initialRoute: '/',
      routes: {
        '/': (context) => const ConnectionScreen(),
        '/student-list': (context) => const StudentListScreen(),
        '/student-details': (context) => const StudentDetailsScreen(),
        '/add-student': (context) => const AddStudentScreen(),
        '/enroll': (context) => const EnrollScreen(),
        '/subject-list': (context) => const SubjectListScreen(),
        '/subject-details': (context) => const SubjectDetailsScreen(),
      },
    );
  }
}
