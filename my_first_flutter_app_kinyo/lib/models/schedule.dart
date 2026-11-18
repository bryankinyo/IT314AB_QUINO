// Model: data class sa Schedule
class Schedule {
  final int? id;
  final int subjectId;
  final String day; // day of week sa database
  final String startTime; // format: HH:MM (24-hour)
  final String endTime;
  final String room;
  final int slotCapacity;

  // mga extra info gikan sa JOIN (para sa display ra)
  final String? subjectCode;
  final String? subjectName;
  final int enrolledCount;

  const Schedule({
    this.id,
    required this.subjectId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.slotCapacity,
    this.subjectCode,
    this.subjectName,
    this.enrolledCount = 0,
  });

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['schedule_id'],
      subjectId: map['subject_id'],
      day: map['day_of_week'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      room: map['room'],
      slotCapacity: map['slot_capacity'],
      subjectCode: map['subject_code'],
      subjectName: map['subject_name'],
      enrolledCount: (map['enrolled_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject_id': subjectId,
      'day_of_week': day,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'slot_capacity': slotCapacity,
    };
  }
}
