// Model: data class sa Grade
class Grade {
  final int? id;
  final int enrollmentId;
  final double gradeValue;
  final String? remarks;

  const Grade({
    this.id,
    required this.enrollmentId,
    required this.gradeValue,
    this.remarks,
  });

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['grade_id'],
      enrollmentId: map['enrollment_id'],
      gradeValue: (map['grade_value'] as num).toDouble(),
      remarks: map['remarks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enrollment_id': enrollmentId,
      'grade_value': gradeValue,
      'remarks': remarks,
    };
  }
}
