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
        if (!mounted) return;
        scheduleVM.loadAll();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text(
          'Enroll Student',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF243B63),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      body: Column(
        children: [
          // STUDENT INFORMATION
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF243B63),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ENROLLING STUDENT',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        student!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // AVAILABLE SCHEDULES HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Icon(
                  Icons.event_available_outlined,
                  color: Color(0xFF243B63),
                  size: 23,
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'Available Schedules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF243B63),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListenableBuilder(
              listenable: scheduleVM,
              builder: (context, child) {
                if (scheduleVM.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF243B63)),
                  );
                }

                if (scheduleVM.errorMessage != null) {
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
                            scheduleVM.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: scheduleVM.loadAll,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
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
                          'No schedules available.',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Add a schedule first in Subjects.',
                          style: TextStyle(color: Colors.blueGrey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: scheduleVM.schedules.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final schedule = scheduleVM.schedules[index];

                    final slotsLeft =
                        schedule.slotCapacity - schedule.enrolledCount;

                    final isFull = slotsLeft <= 0;

                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 1,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SUBJECT INFORMATION
                            Text(
                              '${schedule.subjectCode} - ${schedule.subjectName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF243B63),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // CLASS DAY AND TIME
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 17,
                                  color: Colors.blueGrey.shade500,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    schedule.day,
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 7),

                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 17,
                                  color: Colors.blueGrey.shade500,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${schedule.startTime} - ${schedule.endTime}',
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade700,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 7),

                            Row(
                              children: [
                                Icon(
                                  Icons.meeting_room_outlined,
                                  size: 17,
                                  color: Colors.blueGrey.shade500,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Room ${schedule.room}',
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 12),

                            // AVAILABLE SLOTS AND ENROLL BUTTON
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Available Slots',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueGrey.shade500,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '$slotsLeft / ${schedule.slotCapacity}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: isFull
                                              ? Colors.red.shade700
                                              : const Color(0xFF243B63),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                ElevatedButton.icon(
                                  // disabled kung wala nay slots
                                  onPressed: isFull
                                      ? null
                                      : () async {
                                          // ENROLLMENT WORKFLOW naa sa ViewModel
                                          final error = await enrollmentVM
                                              .enroll(student!.id!, schedule);

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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF243B63),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        Colors.grey.shade300,
                                    disabledForegroundColor:
                                        Colors.grey.shade600,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 11,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: Icon(
                                    isFull
                                        ? Icons.block
                                        : Icons.person_add_alt_1,
                                    size: 18,
                                  ),
                                  label: Text(isFull ? 'Full' : 'Enroll'),
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
    );
  }
}
