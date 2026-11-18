// Model: data class sa Student. Row <-> object conversion ra ang buhaton diri
class Student {
  final int? id; // student_id gikan sa database (null kung bag-o pa)
  final String name;
  final int? programId;

  // gikan sa JOIN sa program table (para sa display ra)
  final String? programCode;
  final String? programName;

  const Student({
    this.id,
    required this.name,
    this.programId,
    this.programCode,
    this.programName,
  });

  // i-convert ang row gikan sa database ngadto sa Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['student_id'],
      name: map['student_name'],
      programId: map['program_id'],
      programCode: map['program_code'],
      programName: map['program_name'],
    );
  }

  // i-convert ang Student ngadto sa Map para ma-insert/update sa database
  Map<String, dynamic> toMap() {
    return {'student_name': name, 'program_id': programId};
  }
}
