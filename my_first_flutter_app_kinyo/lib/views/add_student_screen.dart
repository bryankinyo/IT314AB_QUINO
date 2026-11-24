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

  // i-save ang bag-ong student kung sakto ang mga input
  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    final studentToAdd = Student(
      name: nameController.text.trim(),
      programId: selectedProgramId,
    );

    // i-save sa database through ViewModel
    final error = await studentVM.addStudent(studentToAdd);
    if (!mounted) return;

    if (error != null) {
      showMessage(context, error);
      return;
    }

    showMessage(context, 'Student added successfully!');
    Navigator.pop(context);
  }

  // i-clear ang form kung gusto mag start balik
  void _clearForm() {
    _formKey.currentState?.reset();
    nameController.clear();

    setState(() {
      selectedProgramId = null;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          'Add Student',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF243B63),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.person_add_alt_1,
              size: 48,
              color: Color(0xFF243B63),
            ),
            const SizedBox(height: 12),
            const Text(
              'New Student Information',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF243B63),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Fill in the details below to create a student profile.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey.shade600),
            ),
            const SizedBox(height: 22),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name: dili pwede empty, labing menos 2 ka letra
                      TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter student name',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: validateName,
                      ),
                      const SizedBox(height: 18),

                      // Program: dapat naay mapili gikan sa programs sa database
                      DropdownButtonFormField<int>(
                        initialValue: selectedProgramId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Program',
                          prefixIcon: const Icon(Icons.school_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                          setState(() {
                            selectedProgramId = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Program is required' : null,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: _saveStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF243B63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Student'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _clearForm,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF243B63),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear Form'),
            ),
            TextButton(
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