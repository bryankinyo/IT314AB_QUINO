import 'package:flutter/foundation.dart';
import '../models/program.dart';
import '../models/student.dart';
import '../repositories/program_repository.dart';
import '../repositories/student_repository.dart';

// ViewModel: nag-hold sa state (list, loading, error) ug nag-tawag sa repository
// ang add/update/delete mo-return ug error message. null = success
class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repo = StudentRepository();
  final ProgramRepository _programRepo = ProgramRepository();

  List<Student> students = [];
  List<Program> programs = []; // para sa program dropdown
  bool isLoading = false;
  String? errorMessage; // error sa pag-load ra

  Future<void> loadStudents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      students = await _repo.getAll();
      programs = await _programRepo.getAll();
    } catch (e) {
      errorMessage = 'Failed to load students: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> addStudent(Student student) async {
    try {
      await _repo.add(student);
      await loadStudents();
      return null;
    } catch (e) {
      return 'Failed to add student: $e';
    }
  }

  Future<String?> updateStudent(Student student) async {
    try {
      await _repo.update(student);
      await loadStudents();
      return null;
    } catch (e) {
      return 'Failed to update student: $e';
    }
  }

  Future<String?> deleteStudent(int id) async {
    try {
      await _repo.delete(id);
      await loadStudents();
      return null;
    } catch (e) {
      return 'Cannot delete student: ${e.toString().replaceFirst('Exception: ', '')}';
    }
  }
}

// usa ra ka instance nga gamiton sa tanang screens
final studentVM = StudentViewModel();
