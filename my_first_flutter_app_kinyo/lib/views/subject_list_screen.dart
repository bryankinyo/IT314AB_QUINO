
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
    final codeController = TextEditingController(
      text: subject?.code ?? '',
    );
    final nameController = TextEditingController(
      text: subject?.name ?? '',
    );
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            subject == null ? 'Add Subject' : 'Edit Subject',
            style: const TextStyle(
              color: Color(0xFF243B63),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: 'Subject Code',
                      prefixIcon: const Icon(Icons.code),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        validateRequired(v, 'Subject Code'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Subject Name',
                      prefixIcon: const Icon(Icons.menu_book_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        validateRequired(v, 'Subject Name'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: unitsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Units',
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        validatePositiveNumber(v, 'Units'),
                  ),
                  const SizedBox(height: 14),
                  // description: optional
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description (optional)',
                      prefixIcon: const Icon(Icons.description_outlined),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF243B63),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final updatedSubject = Subject(
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
                  error = await subjectVM.addSubject(updatedSubject);
                } else {
                  error = await subjectVM.updateSubject(updatedSubject);
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

  // tangtangon ang subject human ma-confirm sa user
  Future<void> _deleteSubject(Subject subject) async {
    final confirmed = await confirmDialog(
      context,
      'Delete Subject',
      'Delete ${subject.name}? Its schedules and enrollments will also be deleted.',
    );

    if (!confirmed) return;

    final error = await subjectVM.deleteSubject(subject.id!);

    if (!mounted) return;

    showMessage(context, error ?? 'Subject deleted');
  }

  // mo-adto sa details sa napiling subject
  void _openSubjectDetails(Subject subject) {
    Navigator.pushNamed(
      context,
      '/subject-details',
      arguments: subject,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text(
          'Subjects',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF243B63),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSubjectDialog();
        },
        backgroundColor: const Color(0xFF243B63),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Subject'),
      ),

      body: ListenableBuilder(
        listenable: subjectVM,
        builder: (context, child) {
          if (subjectVM.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF243B63),
              ),
            );
          }

          if (subjectVM.errorMessage != null) {
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
                    Text(
                      subjectVM.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: subjectVM.loadSubjects,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (subjectVM.subjects.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 54,
                    color: Colors.blueGrey.shade300,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No subjects available.',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Add a subject to get started.',
                    style: TextStyle(
                      color: Colors.blueGrey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 90),
            itemCount: subjectVM.subjects.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final subject = subjectVM.subjects[index];

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
                    vertical: 10,
                  ),
                  onTap: () {
                    // adto sa subject details (schedules)
                    _openSubjectDetails(subject);
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFE4EBF6),
                    foregroundColor: const Color(0xFF243B63),
                    child: const Icon(Icons.menu_book_outlined),
                  ),
                  title: Text(
                    '${subject.code} - ${subject.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF243B63),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Units: ${subject.units}'
                      '${subject.description == null ? '' : '\n${subject.description}'}',
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    tooltip: 'Subject options',
                    onSelected: (choice) {
                      if (choice == 'edit') {
                        _showSubjectDialog(subject: subject);
                      } else if (choice == 'delete') {
                        _deleteSubject(subject);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
                            SizedBox(width: 10),
                            Text('Edit Subject'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.deepOrange,
                            ),
                            SizedBox(width: 10),
                            Text('Delete Subject'),
                          ],
                        ),
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
