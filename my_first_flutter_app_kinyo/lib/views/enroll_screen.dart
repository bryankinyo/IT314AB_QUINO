import 'package:flutter/material.dart';
import '../models/student.dart';
import '../viewmodels/enrollment_viewmodel.dart';
import '../viewmodels/schedule_viewmodel.dart';
import 'helpers.dart';

// ENROLL SCREEN
// pili ug schedule (subject) para i-enroll ang student
class EnrollScreen extends StatefulWidget {
  const EnrollScreen({super.key});

  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  Student? student;

  @override
  Widget build(BuildContext context) {
    // ang student nga gipasa gikan sa details screen
    if (student == null) {
      student = ModalRoute.of(context)!.settings.arguments as Student;

      // i-load ang tanang available schedules
      scheduleVM.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scheduleVM.loadAll();
      });
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Enroll Student'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Enrolling: ${student!.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListenableBuilder(
              listenable: scheduleVM,
              builder: (context, child) {
                if (scheduleVM.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (scheduleVM.errorMessage != null) {
                  return Center(child: Text(scheduleVM.errorMessage!));
                }

                if (scheduleVM.schedules.isEmpty) {
                  return const Center(
                    child: Text('No schedules available. Add one in Subjects.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: scheduleVM.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = scheduleVM.schedules[index];
                    final slotsLeft = schedule.slotCapacity - schedule.enrolledCount;

                    return Card(
                      child: ListTile(
                        title: Text(
                          '${schedule.subjectCode} - ${schedule.subjectName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${schedule.day} ${schedule.startTime} - ${schedule.endTime}\n'
                          'Room ${schedule.room} | Slots left: $slotsLeft/${schedule.slotCapacity}',
                        ),
                        isThreeLine: true,
                        trailing: ElevatedButton(
                          // disabled kung wala nay slots
                          onPressed: slotsLeft <= 0
                              ? null
                              : () async {
                                  // ENROLLMENT WORKFLOW naa sa ViewModel
                                  final error = await enrollmentVM.enroll(
                                    student!.id!,
                                    schedule,
                                  );
                                  if (!mounted) return;

                                  if (error != null) {
                                    // invalid: ipakita ang error
                                    showMessage(context, error);
                                    return;
                                  }

                                  // success
                                  showMessage(
                                    context,
                                    'Enrolled in ${schedule.subjectCode} successfully!',
                                  );
                                  Navigator.pop(context);
                                },
                          child: Text(slotsLeft <= 0 ? 'Full' : 'Enroll'),
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
    );
  }
}
