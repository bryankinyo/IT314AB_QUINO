import 'package:flutter/material.dart';
import '../viewmodels/student_viewmodel.dart';
import 'helpers.dart';

// STUDENT LIST SCREEN
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    // i-load ang students gikan sa database pagsugod sa screen
    studentVM.loadStudents();
  }

  // mo-open sa profile sa napiling student
  void _openStudentProfile(student) {
    Navigator.pushNamed(context, '/student-details', arguments: student);
  }

  // mangayo sa confirmation una tangtangon ang student
  Future<void> _removeStudent(student) async {
    final confirmed = await confirmDialog(
      context,
      'Delete Student',
      'Delete ${student.name}? Their enrollments and grades will also be deleted.',
    );

    if (!confirmed) return;

    final error = await studentVM.deleteStudent(student.id!);
    if (!mounted) return;

    showMessage(context, error ?? 'Student deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          'Student Profiles',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF243B63),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // adto sa subjects screen
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/subject-list');
            },
            icon: const Icon(Icons.menu_book_outlined),
            tooltip: 'Subjects',
          ),
        ],
      ),

      // mao ni ang floating action button nga nag navigate sa add student screen
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-student');
        },
        backgroundColor: const Color(0xFF243B63),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Student'),
      ),

      // ListenableBuilder = mo-rebuild kung mo-change ang studentVM
      body: ListenableBuilder(
        listenable: studentVM,
        builder: (context, child) {
          // 1. loading state
          if (studentVM.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF243B63)),
            );
          }

          // 2. error state
          if (studentVM.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_outlined,
                      size: 42,
                      color: Colors.blueGrey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(studentVM.errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: studentVM.loadStudents,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. empty state
          if (studentVM.students.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.groups_2_outlined,
                    size: 54,
                    color: Colors.blueGrey.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No student profiles available.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Add a student to get started.',
                    style: TextStyle(color: Colors.blueGrey.shade500),
                  ),
                ],
              ),
            );
          }

          // 4. data state
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 90),
            itemCount: studentVM.students.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final student = studentVM.students[index];

              return Card(
                margin: EdgeInsets.zero,
                elevation: 1,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  onTap: () {
                    // adto sa details screen ug ipasa ang student
                    _openStudentProfile(student);
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFE4EBF6),
                    foregroundColor: const Color(0xFF243B63),
                    child: Text(
                      initialOf(student.name),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  title: Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF243B63),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'ID: ${student.id}\n'
                      'Program: ${student.programName ?? 'N/A'}',
                      style: TextStyle(
                        height: 1.45,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    onPressed: () {
                      _removeStudent(student);
                    },
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.deepOrange,
                    tooltip: 'Delete Student',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
