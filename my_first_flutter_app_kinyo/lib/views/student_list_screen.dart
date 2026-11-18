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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Student Profiles'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          // adto sa subjects screen
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/subject-list');
            },
            icon: const Icon(Icons.menu_book),
            tooltip: 'Subjects',
          ),
        ],
      ),

      // mao ni ang floating action button nga nag navigate sa add student screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-student');
        },
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),

      // ListenableBuilder = mo-rebuild kung mo-change ang studentVM
      body: ListenableBuilder(
        listenable: studentVM,
        builder: (context, child) {
          // 1. loading state
          if (studentVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. error state
          if (studentVM.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(studentVM.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: studentVM.loadStudents,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // 3. empty state
          if (studentVM.students.isEmpty) {
            return const Center(
              child: Text(
                'No student profiles available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // 4. data state
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: studentVM.students.length,
            itemBuilder: (context, index) {
              final student = studentVM.students[index];

              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () {
                    // adto sa details screen ug ipasa ang student
                    Navigator.pushNamed(
                      context,
                      '/student-details',
                      arguments: student,
                    );
                  },
                  leading: CircleAvatar(child: Text(initialOf(student.name))),
                  title: Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'ID: ${student.id}\n'
                    'Program: ${student.programName ?? 'N/A'}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    onPressed: () async {
                      final yes = await confirmDialog(
                        context,
                        'Delete Student',
                        'Delete ${student.name}? Their enrollments and grades will also be deleted.',
                      );
                      if (!yes) return;

                      final error = await studentVM.deleteStudent(student.id!);
                      if (!context.mounted) return;
                      showMessage(context, error ?? 'Student deleted');
                    },
                    icon: const Icon(Icons.delete),
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
