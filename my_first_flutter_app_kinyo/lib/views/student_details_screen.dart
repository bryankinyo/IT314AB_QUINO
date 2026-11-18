import 'package:flutter/material.dart';
import '../models/enrollment.dart';
import '../models/student.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/grade_viewmodel.dart';
import '../viewmodels/schedule_viewmodel.dart';
import '../viewmodels/student_viewmodel.dart';
import 'helpers.dart';

// STUDENT DETAILS SCREEN
// diri makita ang student info, enrolled subjects, ug grades
class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  // ang student nga gipakita karon sa screen
  Student? currentStudent;

  // EDIT STUDENT DIALOG
  void _showEditDialog(Student student) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: student.name);

    // i-check kung naa pa ang program sa list, kung wala null
    int? selectedProgramId =
        studentVM.programs.any((p) => p.id == student.programId)
        ? student.programId
        : null;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: validateName,
                  ),
                  DropdownButtonFormField<int>(
                    initialValue: selectedProgramId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Program'),
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                // maghimo ug updated nga student gamit ang gi-edit nga info
                final updated = Student(
                  id: student.id,
                  name: nameController.text.trim(),
                  programId: selectedProgramId,
                );

                // i-save sa database through ViewModel
                final error = await studentVM.updateStudent(updated);
                if (!dialogContext.mounted) return;

                if (error != null) {
                  showMessage(dialogContext, error);
                  return;
                }

                Navigator.pop(dialogContext);

                // i-update ang gipakita sa screen (kuhaon sa reloaded list para naay program name)
                setState(() {
                  currentStudent = studentVM.students.firstWhere(
                    (s) => s.id == student.id,
                    orElse: () => updated,
                  );
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // GRADE DIALOG (para sa add ug edit)
  void _showGradeDialog(Enrollment enrollment) {
    final formKey = GlobalKey<FormState>();
    final gradeController = TextEditingController(
      text: enrollment.grade?.toString() ?? '',
    );
    final remarksController = TextEditingController(
      text: enrollment.remarks ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(enrollment.grade == null ? 'Add Grade' : 'Edit Grade'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: gradeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText:
                          'Grade for ${enrollment.subjectCode} (1.00-5.00)',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Grade is required';
                      }
                      final grade = double.tryParse(value.trim());
                      if (grade == null || grade < 1.00 || grade > 5.00) {
                        return 'Grade must be from 1.00 to 5.00';
                      }
                      return null;
                    },
                  ),
                  // remarks: optional
                  TextFormField(
                    controller: remarksController,
                    decoration: const InputDecoration(
                      labelText: 'Remarks (optional)',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final value = double.parse(gradeController.text.trim());
                final remarksText = remarksController.text.trim();
                final String? remarks = remarksText.isEmpty
                    ? null
                    : remarksText;

                // kung wala pay grade = add, kung naa na = update
                final String? error;
                if (enrollment.gradeId == null) {
                  error = await gradeVM.addGrade(
                    enrollment.id!,
                    value,
                    remarks,
                  );
                } else {
                  error = await gradeVM.updateGrade(
                    enrollment.gradeId!,
                    value,
                    remarks,
                  );
                }
                if (!dialogContext.mounted) return;

                if (error != null) {
                  showMessage(dialogContext, error);
                  return;
                }

                Navigator.pop(dialogContext);
                // i-reload ang enrollments para makita ang bag-ong grade
                enrollmentVM.loadEnrollments(enrollment.studentId);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // CHANGE SCHEDULE DIALOG: pili ug lain nga schedule sa same subject
  void _showChangeScheduleDialog(Enrollment enrollment) async {
    await scheduleVM.loadBySubject(enrollment.subjectId);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Change Schedule - ${enrollment.subjectCode}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: scheduleVM.schedules.length,
              itemBuilder: (context, index) {
                final schedule = scheduleVM.schedules[index];
                final slotsLeft =
                    schedule.slotCapacity - schedule.enrolledCount;

                return ListTile(
                  title: Text(
                    '${schedule.day} ${schedule.startTime} - ${schedule.endTime}',
                  ),
                  subtitle: Text(
                    'Room ${schedule.room} | Slots left: $slotsLeft',
                  ),
                  // check icon kung mao na ni ang karon nga schedule
                  trailing: schedule.id == enrollment.scheduleId
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () async {
                    Navigator.pop(dialogContext);
                    final error = await enrollmentVM.changeSchedule(
                      enrollment,
                      schedule,
                    );
                    if (!mounted) return;
                    showMessage(context, error ?? 'Schedule changed!');
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ang student nga gipasa gikan sa list through route arguments
    if (currentStudent == null) {
      currentStudent = ModalRoute.of(context)!.settings.arguments as Student;

      // i-load ang enrolled subjects sa student (human ma-build ang screen)
      enrollmentVM.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        enrollmentVM.loadEnrollments(currentStudent!.id!);
      });
    }
    final student = currentStudent!;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showEditDialog(student);
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Student',
          ),
          IconButton(
            onPressed: () async {
              final yes = await confirmDialog(
                context,
                'Delete Student',
                'Delete ${student.name}? Their enrollments and grades will also be deleted.',
              );
              if (!yes) return;

              final error = await studentVM.deleteStudent(student.id!);
              if (!mounted) return;

              if (error != null) {
                showMessage(context, error);
                return;
              }
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Student',
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // STUDENT INFO
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Text(initialOf(student.name)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Student ID: ${student.id}'),
                          Text('Program: ${student.programName ?? 'N/A'}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // HEADER + ENROLL BUTTON
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Enrolled Subjects',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // adto sa enroll screen ug ipasa ang student
                    Navigator.pushNamed(context, '/enroll', arguments: student);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Enroll'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // LIST SA ENROLLED SUBJECTS
            Expanded(
              child: ListenableBuilder(
                listenable: enrollmentVM,
                builder: (context, child) {
                  if (enrollmentVM.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (enrollmentVM.errorMessage != null) {
                    return Center(child: Text(enrollmentVM.errorMessage!));
                  }

                  if (enrollmentVM.enrollments.isEmpty) {
                    return const Center(
                      child: Text('Not enrolled in any subject yet.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: enrollmentVM.enrollments.length,
                    itemBuilder: (context, index) {
                      final enrollment = enrollmentVM.enrollments[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${enrollment.subjectCode} - ${enrollment.subjectName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${enrollment.day} ${enrollment.startTime} - ${enrollment.endTime} | Room ${enrollment.room}',
                              ),
                              Text('Status: ${enrollment.status}'),
                              Text(
                                enrollment.grade == null
                                    ? 'Grade: No grade yet'
                                    : 'Grade: ${enrollment.grade}',
                              ),
                              // ipakita ang remarks kung naa
                              if (enrollment.remarks != null)
                                Text('Remarks: ${enrollment.remarks}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // add or edit grade
                                  IconButton(
                                    onPressed: () {
                                      _showGradeDialog(enrollment);
                                    },
                                    icon: Icon(
                                      enrollment.grade == null
                                          ? Icons.grade_outlined
                                          : Icons.grade,
                                    ),
                                    tooltip: enrollment.grade == null
                                        ? 'Add Grade'
                                        : 'Edit Grade',
                                  ),

                                  // delete grade (makita ra kung naay grade)
                                  if (enrollment.gradeId != null)
                                    IconButton(
                                      onPressed: () async {
                                        final yes = await confirmDialog(
                                          context,
                                          'Delete Grade',
                                          'Delete grade for ${enrollment.subjectCode}?',
                                        );
                                        if (!yes) return;

                                        final error = await gradeVM.deleteGrade(
                                          enrollment.gradeId!,
                                        );
                                        if (!mounted) return;

                                        if (error != null) {
                                          showMessage(context, error);
                                          return;
                                        }
                                        enrollmentVM.loadEnrollments(
                                          student.id!,
                                        );
                                      },
                                      icon: const Icon(Icons.grade_outlined),
                                      color: Colors.red,
                                      tooltip: 'Delete Grade',
                                    ),

                                  // change schedule
                                  IconButton(
                                    onPressed: () {
                                      _showChangeScheduleDialog(enrollment);
                                    },
                                    icon: const Icon(Icons.swap_horiz),
                                    tooltip: 'Change Schedule',
                                  ),

                                  // drop subject
                                  IconButton(
                                    onPressed: () async {
                                      final yes = await confirmDialog(
                                        context,
                                        'Drop Subject',
                                        'Drop ${enrollment.subjectCode}?',
                                      );
                                      if (!yes) return;

                                      final error = await enrollmentVM
                                          .dropEnrollment(enrollment);
                                      if (!mounted) return;
                                      showMessage(
                                        context,
                                        error ?? 'Subject dropped',
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Drop Subject',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
