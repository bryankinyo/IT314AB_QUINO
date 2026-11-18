import 'package:flutter/foundation.dart';
import '../models/schedule.dart';
import '../repositories/schedule_repository.dart';

// ViewModel para sa schedules
class ScheduleViewModel extends ChangeNotifier {
  final ScheduleRepository _repo = ScheduleRepository();

  List<Schedule> schedules = [];
  bool isLoading = false;
  String? errorMessage;
  int? currentSubjectId; // kung naa, schedules sa subject ra ang gi-load

  // i-clear ang karaan nga data una mag-open ug screen (walay notify)
  void reset() {
    schedules = [];
    isLoading = true;
    errorMessage = null;
  }

  Future<void> loadAll() async {
    currentSubjectId = null;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      schedules = await _repo.getAll();
    } catch (e) {
      errorMessage = 'Failed to load schedules: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadBySubject(int subjectId) async {
    currentSubjectId = subjectId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      schedules = await _repo.getBySubject(subjectId);
    } catch (e) {
      errorMessage = 'Failed to load schedules: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  // i-reload ang list human sa add/update/delete
  Future<void> _reload() async {
    if (currentSubjectId == null) {
      await loadAll();
    } else {
      await loadBySubject(currentSubjectId!);
    }
  }

  Future<String?> addSchedule(Schedule schedule) async {
    try {
      await _repo.add(schedule);
      await _reload();
      return null;
    } catch (e) {
      return 'Failed to add schedule: $e';
    }
  }

  Future<String?> updateSchedule(Schedule schedule) async {
    try {
      await _repo.update(schedule);
      await _reload();
      return null;
    } catch (e) {
      return 'Failed to update schedule: $e';
    }
  }

  Future<String?> deleteSchedule(int id) async {
    try {
      await _repo.delete(id);
      await _reload();
      return null;
    } catch (e) {
      return 'Failed to delete schedule: $e';
    }
  }
}

final scheduleVM = ScheduleViewModel();
