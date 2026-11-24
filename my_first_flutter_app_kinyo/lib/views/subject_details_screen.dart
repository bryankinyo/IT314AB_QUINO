
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

    final endController = TextEditingController(
      text: schedule?.endTime ?? '',
    );

    final roomController = TextEditingController(
      text: schedule?.room ?? '',
    );

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            schedule == null ? 'Add Schedule' : 'Edit Schedule',
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
                  DropdownButtonFormField<String>(
                    initialValue: selectedDay,
                    decoration: InputDecoration(
                      labelText: 'Day',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: dayOptions
                        .map(
                          (day) => DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedDay = value;
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: startController,
                    decoration: InputDecoration(
                      labelText: 'Start Time (HH:MM)',
                      prefixIcon: const Icon(Icons.access_time),
                      hintText: '08:00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: validateTime,
                  ),
                  const SizedBox(height: 14),

                  // End time: dapat format sakto ug mas ulahi kaysa start time
                  TextFormField(
                    controller: endController,
                    decoration: InputDecoration(
                      labelText: 'End Time (HH:MM)',
                      prefixIcon: const Icon(Icons.access_time_filled),
                      hintText: '10:00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      final error = validateTime(value);
                      if (error != null) return error;

                      if (value!.trim().compareTo(
                            startController.text.trim(),
                          ) <=
                          0) {
                        return 'End time must be after start time';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: roomController,
                    decoration: InputDecoration(
                      labelText: 'Room',
                      prefixIcon: const Icon(Icons.meeting_room_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => validateRequired(v, 'Room'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: slotsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Max Slots',
                      prefixIcon: const Icon(Icons.groups_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => validatePositiveNumber(v, 'Max Slots'),
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
              child: const Text('Save Schedule'),
            ),
          ],
        );
      },
    );
  }

  // tangtangon ang schedule human ma-confirm sa user
  Future<void> _deleteSchedule(Schedule schedule) async {
    final confirmed = await confirmDialog(
      context,
      'Delete Schedule',
      'Delete this schedule? Enrollments in it will also be deleted.',
    );

    if (!confirmed) return;

    final error = await scheduleVM.deleteSchedule(schedule.id!);

    if (!mounted) return;

    showMessage(context, error ?? 'Schedule deleted');
  }

  // i-load ang subject details gikan sa subject list
  void _loadSubjectDetails() {
    subject = ModalRoute.of(context)!.settings.arguments as Subject;

    // i-load ang schedules sa subject (human ma-build ang screen)
    scheduleVM.reset();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      scheduleVM.loadBySubject(subject!.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ang subject nga gipasa gikan sa subject list
    if (subject == null) {
      _loadSubjectDetails();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text(
          'Subject Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF243B63),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showScheduleDialog();
        },
        backgroundColor: const Color(0xFF243B63),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Schedule'),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SUBJECT INFORMATION CARD
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4EBF6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.menu_book_outlined,
                            color: Color(0xFF243B63),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject!.name,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF243B63),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subject!.code,
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 26),
                    Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          color: Color(0xFF243B63),
                          size: 20,
                        ),
                        const SizedBox(width: 9),
                        Text(
                          '${subject!.units} Units',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (subject!.description != null &&
                        subject!.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        subject!.description!,
                        style: TextStyle(
                          color: Colors.blueGrey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // SCHEDULE SECTION
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xFF243B63),
                  size: 23,
                ),
                const SizedBox(width: 9),
                const Text(
                  'Class Schedules',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF243B63),
                  ),
                ),
                const Spacer(),
                Text(
                  '${scheduleVM.schedules.length} total',
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListenableBuilder(
                listenable: scheduleVM,
                builder: (context, child) {
                  if (scheduleVM.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF243B63),
                      ),
                    );
                  }

                  if (scheduleVM.errorMessage != null) {
                    return Center(
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
                            scheduleVM.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: () {
                              scheduleVM.loadBySubject(subject!.id!);
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (scheduleVM.schedules.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_busy_outlined,
                            size: 54,
                            color: Colors.blueGrey.shade300,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No schedules yet.',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Tap Add Schedule to create one.',
                            style: TextStyle(
                              color: Colors.blueGrey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 90),
                    itemCount: scheduleVM.schedules.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final schedule = scheduleVM.schedules[index];

                      final slotsLeft =
                          schedule.slotCapacity - schedule.enrolledCount;

                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 1,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 82,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF243B63),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schedule.day,
                                      style: const TextStyle(
                                        color: Color(0xFF243B63),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.blueGrey.shade500,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            '${schedule.startTime} - ${schedule.endTime}',
                                            style: TextStyle(
                                              color: Colors.blueGrey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.meeting_room_outlined,
                                          size: 16,
                                          color: Colors.blueGrey.shade500,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          schedule.room,
                                          style: TextStyle(
                                            color: Colors.blueGrey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.groups_outlined,
                                          size: 16,
                                          color: Colors.blueGrey.shade500,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Slots: $slotsLeft/${schedule.slotCapacity}',
                                          style: TextStyle(
                                            color: Colors.blueGrey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                tooltip: 'Schedule options',
                                onSelected: (choice) {
                                  if (choice == 'edit') {
                                    _showScheduleDialog(
                                      schedule: schedule,
                                    );
                                  } else if (choice == 'delete') {
                                    _deleteSchedule(schedule);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text('Edit Schedule'),
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
                                        Text('Delete Schedule'),
                                      ],
                                    ),
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
