// Model: data class sa Program (para sa dropdown sa student form)
class Program {
  final int id;
  final String code;
  final String name;

  const Program({required this.id, required this.code, required this.name});

  factory Program.fromMap(Map<String, dynamic> map) {
    return Program(
      id: map['program_id'],
      code: map['program_code'],
      name: map['program_name'],
    );
  }
}
