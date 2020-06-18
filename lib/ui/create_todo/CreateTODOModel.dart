import 'package:flutter/foundation.dart';
import 'package:todolist/model/TODO.dart';
import 'package:todolist/repository/AppRepo.dart';
import 'package:todolist/utils/notification_manager.dart';

class CreateTODOModel extends ChangeNotifier {
  TODO _todo = TODO('');

  /// Get "photo" of [todo].
  /// 
  /// 
  String get photo => _todo.photo;

  /// Get "status" of [todo].
  ///
  ///
  bool get status => _todo.status;

  /// Get "notify" of [todo].
  ///
  ///
  bool get notify => _todo.notify;

  /// Set [todo] attached in this model.
  ///
  ///
  set todo(TODO value) {
    _todo = value;
  }

  /// Set "text" value of [todo].
  ///
  ///
  set text(String value) {
    _todo.text = value;
  }

  /// Set "photo" value of [todo].
  ///
  /// Then [Consumer] of this model will then be notified.
  set photo(String value) {
    if (value == _todo.photo) {
      return;
    }
    _todo.photo = value;
    notifyListeners();
  }

  /// Set "status" value of [todo].
  ///
  /// Then [Consumer] of this model will then be notified.
  set status(bool value) {
    if (value == _todo.status) {
      return;
    }
    _todo.status = value;
    notifyListeners();
  }

  /// Set "notify" value of [todo].
  ///
  /// Then [Consumer] of this model will then be notified.
  set notify(bool value) {
    if (value == _todo.notify) {
      return;
    }
    _todo.notify = value;
    notifyListeners();
  }

  /// Save [todo] instance, attached in this model, to DB.
  /// After saving, it will then schedule a notification for [todo].
  ///
  /// If [todo] has an ID equal to 0, save as new, otherwise, update.
  Future<bool> save() async {
    bool res = false;

    if (_todo.text.isEmpty) {
      return res;
    }

    if (_todo.id == 0) {
      res = await AppRepo.instance.save(_todo);
      scheduleNotification(_todo);
    }
    else {
      res = await AppRepo.instance.update(_todo);
      rescheduleNotification(_todo);
    }

    return res;
  }
}