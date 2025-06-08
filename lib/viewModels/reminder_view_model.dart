import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/reminder.dart';
import 'package:medicationtracker/data/repositories/reminder_repository.dart';

class ReminderViewModel extends ChangeNotifier {
  bool isLoading = false;
  final ReminderRepository _repo = ReminderRepository();

  Future<void> patch(
    String id, {
    DateTime? respondedAt,
    String? actionTaken,
  }) async {
    await _repo.patch(id, actionTaken: actionTaken, respondedAt: respondedAt);
  }

  Future<void> create(Reminder reminder) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.create(reminder);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> remove(String id) async {
    isLoading = true;
    notifyListeners();

    await _repo.remove(id);

    isLoading = false;
    notifyListeners();
  }

  Future<void> update(Reminder reminder) async {
    isLoading = true;
    notifyListeners();

    await _repo.update(reminder);

    isLoading = false;
    notifyListeners();
  }

  Future<Reminder?> findById(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      final reminder = await _repo.findById(id);
      return reminder;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Reminder>> findMany() async {
    isLoading = true;
    notifyListeners();
    try {
      final reminder = await _repo.findMany();
      return reminder;
    } catch (e) {
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
