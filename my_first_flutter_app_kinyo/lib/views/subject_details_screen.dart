import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../models/subject.dart';
import '../viewmodels/schedule_viewmodel.dart';
import 'helpers.dart';

// SUBJECT DETAILS SCREEN
// diri makita ug ma-manage ang schedules sa subject
class SubjectDetailsScreen extends StatefulWidget {
  const SubjectDetailsScreen({super.key});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  Subject? subject;

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // SCHEDULE FORM DIALOG: kung walay schedule = add, kung naay schedule = edit
  void _showScheduleDialog({Schedule? schedule}) {
    final formKey = GlobalKey<FormState>();
    final startController = TextEditingController(
      text: schedule?.startTime ?? '',
    );
    final endController = TextEditingController(text: schedule?.endTime ?? '');
    final roomController = TextEditingController(text: schedule?.room ?? '');
    final slotsController = TextEditingController(
      text: schedule?.slotCapacity.toString() ?? '',
    );
    String selectedDay = schedule?.day ?? days[0];

    // kung ang day sa database wala sa list (lahi ang format), idugang para dili mag-error ang dropdown
    final dayOptions = [...days];
    if (!dayOptions.contains(selectedDay)) {
      dayOptions.add(selectedDay);
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(schedule == null ? 'Add Schedule' : 'Edit Schedule'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedDay,
                    decoration: const InputDecoration(labelText: 'Day'),
                    items: dayOptions
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) {
                      selectedDay = value!;
                    },
                  ),
                  TextFormField(
                    controller: startController,
                    decoration: const InputDecoration(
                      labelText: 'Start Time (HH:MM)',
                    ),
                    validator: validateTime,
                  ),
                  // End time: dapat format sakto ug mas ulahi kaysa start time
                  TextFormField(
                    controller: endController,
                    decoration: const InputDecoration(
                      labelText: 'End Time (HH:MM)',
                    ),
                    validator: (value) {
                      final error = validateTime(value);
                      if (error != null) return error;
                      if (value!.trim().compareTo(startController.text.trim()) <=
                          0) {
                        return 'End time must be after start time';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: roomController,
                    decoration: const InputDecoration(labelText: 'Room'),
                    validator: (v) => validateRequired(v, 'Room'),
                  ),
                  TextFormField(
                    controller: slotsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Max Slots'),
                    validator: (v) => validatePositiveNumber(v, 'Max Slots'),
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

                final newSchedule = Schedule(
                  id: schedule?.id,
                  subjectId: subject!.id!,
                  day: selectedDay,
                  startTime: startController.text.trim(),
                  endTime: endController.text.trim(),
                  room: roomController.text.trim(),
                  slotCapacity: int.parse(slotsController.text.trim()),
                );

                final String? error;
                if (schedule == null) {
                  error = await scheduleVM.addSchedule(newSchedule);
                } else {
                  error = await scheduleVM.updateSchedule(newSchedule);
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
    // ang subject nga gipasa gikan sa subject list
    if (subject == null) {
      subject = ModalRoute.of(context)!.settings.arguments as Subject;

      // i-load ang schedules sa subject (human ma-build ang screen)
      scheduleVM.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scheduleVM.loadBySubject(subject!.id!);
      });
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Subject Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showScheduleDialog();
        },
        tooltip: 'Add Schedule',
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject!.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Code: ${subject!.code}'),
                    Text('Units: ${subject!.units}'),
                    if (subject!.description != null)
                      Text(subject!.description!),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Schedules',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

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
                      child: Text('No schedules yet. Tap + to add one.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: scheduleVM.schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = scheduleVM.schedules[index];
                      final slotsLeft =
                          schedule.slotCapacity - schedule.enrolledCount;

                      return Card(
                        child: ListTile(
                          title: Text(
                            '${schedule.day} ${schedule.startTime} - ${schedule.endTime}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Room: ${schedule.room}\n'
                            'Slots left: $slotsLeft/${schedule.slotCapacity}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showScheduleDialog(schedule: schedule);
                                },
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit Schedule',
                              ),
                              IconButton(
                                onPressed: () async {
                                  final yes = await confirmDialog(
                                    context,
                                    'Delete Schedule',
                                    'Delete this schedule? Enrollments in it will also be deleted.',
                                  );
                                  if (!yes) return;

                                  final error = await scheduleVM
                                      .deleteSchedule(schedule.id!);
                                  if (!mounted) return;
                                  showMessage(
                                    context,
                                    error ?? 'Schedule deleted',
                                  );
                                },
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete Schedule',
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
