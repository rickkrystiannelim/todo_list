import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:todolist/model/TODO.dart';
import 'package:todolist/repository/AppRepo.dart';
import 'package:todolist/utils/notification_manager.dart';

class TODOListModel extends ChangeNotifier {
  List<TODO> _todo = [];

  UnmodifiableListView<TODO> get todos => UnmodifiableListView(_todo);

  /// Notify all [Consumer] of this model.
  ///
  ///
  void refresh() => notifyListeners();

  /// Get all [TODO] from DB.
  ///
  ///
  Future<List<TODO>> getAll() async {
    _todo = await AppRepo.instance.getAll();
    return _todo;
  }

  /// Toggle status of [todo].
  ///
  /// This will automatically update the DB.
  /// Notification of [todo] will also be cancelled if update is successful
  /// and the status is set to "true".
  /// Then [refresh] will be called.
  Future<bool> toggleStatus(TODO todo) async {
    todo.status = !todo.status;
    final successful = await AppRepo.instance.update(todo);

    if (!successful) {
      // Revert status to previous value because DB update failed.
      todo.status = !todo.status;
      return successful;
    }

    if (todo.status) {
      cancelNotification(todo: todo);
    }
    else {
      rescheduleNotification(todo);
    }

    refresh();
    return successful;
  }

  /// Delete [todo] from DB.
  /// After deleting, it will then cancel the notification for [todo].
  /// Then [refresh] will be called.
  Future<bool> delete(TODO todo) async {
    _todo.remove(todo);
    final successful = await AppRepo.instance.delete(todo);

    if (!successful) {
      return successful;
    }

    cancelNotification(todo: todo);
    refresh();
    return successful;
  }

  /// Delete all [TODO] from DB.
  /// After deleting, it will then cancel all notifications.
  /// Then [refresh] will be called.
  Future<bool> deleteAll() async {
    final successful = await AppRepo.instance.deleteAll();

    if (!successful) {
      return successful;
    }

    cancelNotification();
    refresh();
    return successful;
  }
}