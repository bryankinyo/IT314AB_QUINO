// Model: data class sa Enrollment
// naa ang subject/schedule/grade info kay JOIN ang query (para sa display ra)
class Enrollment {
  final int? id;
  final int studentId;
  final int subjectId;
  final int scheduleId;
  final String status;

  final String subjectCode;
  final String subjectName;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final int? gradeId; // null kung wala pay grade
  final double? grade;
  final String? remarks;

  const Enrollment({
    this.id,
    required this.studentId,
    required this.subjectId,
    required this.scheduleId,
    this.status = 'Enrolled',
    this.subjectCode = '',
    this.subjectName = '',
    this.day = '',
    this.startTime = '',
    this.endTime = '',
    this.room = '',
    this.gradeId,
    this.grade,
    this.remarks,
  });

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      id: map['enrollment_id'],
      studentId: map['student_id'],
      subjectId: map['subject_id'],
      scheduleId: map['schedule_id'],
      status: map['status'] ?? 'Enrolled',
      subjectCode: map['subject_code'],
      subjectName: map['subject_name'],
      day: map['day_of_week'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      room: map['room'],
      gradeId: map['grade_id'],
      grade: (map['grade_value'] as num?)?.toDouble(),
      remarks: map['remarks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'subject_id': subjectId,
      'schedule_id': scheduleId,
      'status': status,
    };
  }
}
