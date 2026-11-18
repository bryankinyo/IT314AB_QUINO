import 'package:flutter/foundation.dart';
import '../models/subject.dart';
import '../repositories/subject_repository.dart';

// ViewModel para sa subjects
class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository _repo = SubjectRepository();

  List<Subject> subjects = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSubjects() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      subjects = await _repo.getAll();
    } catch (e) {
      errorMessage = 'Failed to load subjects: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> addSubject(Subject subject) async {
    try {
      // dili pwede duplicate ang subject code
      if (await _repo.codeExists(subject.code)) {
        return 'Subject code already exists.';
      }
      await _repo.add(subject);
      await loadSubjects();
      return null;
    } catch (e) {
      return 'Failed to add subject: $e';
    }
  }

  Future<String?> updateSubject(Subject subject) async {
    try {
      if (await _repo.codeExists(subject.code, excludeId: subject.id!)) {
        return 'Subject code already exists.';
      }
      await _repo.update(subject);
      await loadSubjects();
      return null;
    } catch (e) {
      return 'Failed to update subject: $e';
    }
  }

  Future<String?> deleteSubject(int id) async {
    try {
      await _repo.delete(id);
      await loadSubjects();
      return null;
    } catch (e) {
      return 'Failed to delete subject: $e';
    }
  }
}

final subjectVM = SubjectViewModel();
