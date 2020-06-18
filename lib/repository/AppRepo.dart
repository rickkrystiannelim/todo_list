import 'package:flutter/services.dart';
import 'package:todolist/model/TODO.dart';

class AppRepo {
  static const _CHANNEL = 'com.lig.todolist/realm';

  static const _ACTION_GET_TODOS = 'getTODOs';
  static const _ACTION_SAVE_TODO = 'save';
  static const _ACTION_UPDATE_TODO = 'update';
  static const _ACTION_DELETE_TODO = 'delete';
  static const _ACTION_DELETE_ALL_TODOS = 'deleteAll';

  static AppRepo _instance;

  final _platform = const MethodChannel(_CHANNEL);

  /// Get singleton instance of this class.
  ///
  ///
  static AppRepo get instance => _instance == null ?
      _instance = new AppRepo._() : _instance;

  /// Private constructor.
  ///
  ///
  AppRepo._();

  /// Get all [TODO] from DB.
  ///
  ///
  Future<List<TODO>> getAll() async {
    List<TODO> result;

    try {
      final rawResult = await _platform.invokeMethod<List<dynamic>>(
        _ACTION_GET_TODOS
      );

      if (rawResult != null) {
        result = rawResult.map(
          (obj) => TODO.from(obj)
        ).toList();
      }
    } on PlatformException catch (e) {
    }

    return result;
  }

  /// Save [todo] from DB.
  ///
  ///
  Future<bool> save(TODO todo) async {
    try {
      final int result = await _platform.invokeMethod(
        _ACTION_SAVE_TODO,
        todo.toMap()
      );

      if (result == 0) {
        return false;
      }

      todo.id = result;
    } on PlatformException catch (e) {
      return false;
    }

    return true;
  }

  /// Update [todo] from DB.
  ///
  ///
  Future<bool> update(TODO todo) async {
    try {
      final int result = await _platform.invokeMethod(
        _ACTION_UPDATE_TODO,
        todo.toMap()
      );

      if (result == 0) {
        return false;
      }
    } on PlatformException catch (e) {
      return false;
    }

    return true;
  }

  /// Delete [todo] from DB.
  ///
  ///
  Future<bool> delete(TODO todo) async {
    try {
      final int result = await _platform.invokeMethod(
        _ACTION_DELETE_TODO,
        todo.toMap()
      );

      if (result == 0) {
        return false;
      }
    } on PlatformException catch (e) {
      return false;
    }

    return true;
  }

  /// Delete all [TODO] from DB.
  ///
  ///
  Future<bool> deleteAll() async {
    try {
      final int result = await _platform.invokeMethod(
        _ACTION_DELETE_ALL_TODOS
      );

      if (result == 0) {
        return false;
      }
    } on PlatformException catch (e) {
      return false;
    }

    return true;
  }
}