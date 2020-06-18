import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todolist/model/TODO.dart';

FlutterLocalNotificationsPlugin _notification;

/// Setup notification plugin.
///
///
Future<FlutterLocalNotificationsPlugin> setupNotificationPlugin() async {
  _notification = FlutterLocalNotificationsPlugin();
  
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  final androidSettings = AndroidInitializationSettings('ic_launcher');
  final iosSettings = IOSInitializationSettings(
    onDidReceiveLocalNotification: _onDidReceiveLocalNotification
  );
  final settings = InitializationSettings(androidSettings, iosSettings);
  
  await _notification.initialize(
    settings,
    onSelectNotification: _selectNotification
  );

  return _notification;
}

///
///
///
Future _onDidReceiveLocalNotification(
  int id, String title, String body, String payload
) async {
  if (payload != null) {
    print('onDidReceiveLocalNotification payload: ' + payload);
  }
}

///
///
///
Future _selectNotification(String payload) async {
  if (payload != null) {
    print('selectNotification payload: ' + payload);
  }
}

/// Schedule notification of [todo].
///
/// If [notification] is null, it will use the [FlutterLocalNotificationsPlugin]
/// of this manager which is created during [setupNotificationPlugin].
void scheduleNotification(
  TODO todo, { FlutterLocalNotificationsPlugin notification }
) async {
  if (_notification == null) {
    return;
  }
  else if (notification == null) {
    notification = _notification;
  }

  final duration = Duration(minutes: todo.notify ? 10 : 5);
  final dateTime = DateTime.now().add(duration);
  
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your other channel id',
    'your other channel name', 
    'your other channel description'
  );
  final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics
  );

  await notification.schedule(
    todo.id,
    'TODO for today!',
    todo.text,
    dateTime,
    platformChannelSpecifics
  );
}

/// Reschedule notification of [todo].
/// This will cancel the scheduled notification of this [todo],
/// then schedule again.
/// 
/// If [notification] is null, it will use the [FlutterLocalNotificationsPlugin]
/// of this manager which is created during [setupNotificationPlugin].
void rescheduleNotification(
  TODO todo, { FlutterLocalNotificationsPlugin notification }
) async {
  cancelNotification(todo: todo, notification: notification);
  scheduleNotification(todo, notification: notification);
}

/// Cancel notification(s).
///
/// If [todo] is set, it will only cancel its notification, otherwise,
/// all notifications will be canceled.
/// 
/// If [notification] is null, it will use the [FlutterLocalNotificationsPlugin]
/// of this manager which is created during [setupNotificationPlugin].
void cancelNotification(
  { TODO todo, FlutterLocalNotificationsPlugin notification }
) async {
  if (_notification == null) {
    return;
  }
  else if (notification == null) {
    notification = _notification;
  }

  if (todo == null) {
    notification.cancelAll();
    return;
  }

  notification.cancel(todo.id);
}