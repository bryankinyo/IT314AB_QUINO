// Model: data class sa Subject
class Subject {
  final int? id;
  final String code;
  final String name;
  final int units;
  final String? description; // optional

  const Subject({
    this.id,
    required this.code,
    required this.name,
    required this.units,
    this.description,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['subject_id'],
      code: map['subject_code'],
      name: map['subject_name'],
      units: map['units'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject_code': code,
      'subject_name': name,
      'units': units,
      'description': description,
    };
  }
}
