import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../viewmodels/subject_viewmodel.dart';
import 'helpers.dart';

// SUBJECT LIST SCREEN
class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  void initState() {
    super.initState();
    subjectVM.loadSubjects();
  }

  // SUBJECT FORM DIALOG: kung walay subject = add, kung naay subject = edit
  void _showSubjectDialog({Subject? subject}) {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController(text: subject?.code ?? '');
    final nameController = TextEditingController(text: subject?.name ?? '');
    final unitsController = TextEditingController(
      text: subject?.units.toString() ?? '',
    );
    final descController = TextEditingController(
      text: subject?.description ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(subject == null ? 'Add Subject' : 'Edit Subject'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Code',
                    ),
                    validator: (v) => validateRequired(v, 'Subject Code'),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                    ),
                    validator: (v) => validateRequired(v, 'Subject Name'),
                  ),
                  TextFormField(
                    controller: unitsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Units'),
                    validator: (v) => validatePositiveNumber(v, 'Units'),
                  ),
                  // description: optional
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
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

                final newSubject = Subject(
                  id: subject?.id,
                  code: codeController.text.trim(),
                  name: nameController.text.trim(),
                  units: int.parse(unitsController.text.trim()),
                  description: descController.text.trim().isEmpty
                      ? null
                      : descController.text.trim(),
                );

                final String? error;
                if (subject == null) {
                  error = await subjectVM.addSubject(newSubject);
                } else {
                  error = await subjectVM.updateSubject(newSubject);
                }
                if (!dialogContext.mounted) return;

                if (error != null) {
                  showMessage(dialogContext, error);
                  return;
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Subjects'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSubjectDialog();
        },
        tooltip: 'Add Subject',
        child: const Icon(Icons.add),
      ),

      body: ListenableBuilder(
        listenable: subjectVM,
        builder: (context, child) {
          if (subjectVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (subjectVM.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(subjectVM.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: subjectVM.loadSubjects,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (subjectVM.subjects.isEmpty) {
            return const Center(
              child: Text(
                'No subjects available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: subjectVM.subjects.length,
            itemBuilder: (context, index) {
              final subject = subjectVM.subjects[index];

              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () {
                    // adto sa subject details (schedules)
                    Navigator.pushNamed(
                      context,
                      '/subject-details',
                      arguments: subject,
                    );
                  },
                  title: Text(
                    '${subject.code} - ${subject.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Units: ${subject.units}'
                    '${subject.description == null ? '' : '\n${subject.description}'}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showSubjectDialog(subject: subject);
                        },
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Subject',
                      ),
                      IconButton(
                        onPressed: () async {
                          final yes = await confirmDialog(
                            context,
                            'Delete Subject',
                            'Delete ${subject.name}? Its schedules and enrollments will also be deleted.',
                          );
                          if (!yes) return;

                          final error = await subjectVM.deleteSubject(
                            subject.id!,
                          );
                          if (!mounted) return;
                          showMessage(context, error ?? 'Subject deleted');
                        },
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete Subject',
                      ),
                    ],
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
