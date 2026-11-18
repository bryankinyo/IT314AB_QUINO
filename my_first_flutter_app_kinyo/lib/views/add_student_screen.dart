import 'package:flutter/material.dart';
import '../models/student.dart';
import '../viewmodels/student_viewmodel.dart';
import 'helpers.dart';

// ADD STUDENT SCREEN
class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  // key para ma validate ang form
  final _formKey = GlobalKey<FormState>();

  // controller para sa name field
  final TextEditingController nameController = TextEditingController();

  // ang program nga gipili sa dropdown
  int? selectedProgramId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            const Text(
              'New Student Information',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name: dili pwede empty, labing menos 2 ka letra
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: validateName,
                      ),

                      const SizedBox(height: 15),

                      // Program: dapat naay mapili gikan sa programs sa database
                      DropdownButtonFormField<int>(
                        initialValue: selectedProgramId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Program',
                          border: OutlineInputBorder(),
                        ),
                        items: studentVM.programs
                            .map(
                              (p) => DropdownMenuItem(
                                value: p.id,
                                child: Text('${p.code} - ${p.name}'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          selectedProgramId = value;
                        },
                        validator: (value) =>
                            value == null ? 'Program is required' : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Create a new Student object with the provided details
                  final newStudent = Student(
                    name: nameController.text.trim(),
                    programId: selectedProgramId,
                  );

                  // i-save sa database through ViewModel
                  final error = await studentVM.addStudent(newStudent);
                  if (!mounted) return;

                  if (error != null) {
                    showMessage(context, error);
                    return;
                  }

                  showMessage(context, 'Student added successfully!');

                  // balik sa student list
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Student'),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
