// import 'dart:isolate';

// import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/ui/NavigationRoute.dart';
import 'package:todolist/ui/create_todo/CreateTODOModel.dart';
import 'package:todolist/ui/create_todo/CreateTODOPage.dart';
import 'package:todolist/ui/home/TODOListModel.dart';
import 'package:todolist/ui/home/TODOListPage.dart';
import 'package:todolist/utils/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await setupNotificationPlugin();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TODOListModel(),
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  static const _TITLE = 'TODOs';
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        NavigationRoute.HOME: (context) => TODOListPage(_TITLE),
        NavigationRoute.CREATE_TODO: (context) => ChangeNotifierProvider(
          create: (context) => CreateTODOModel(),
          child: CreateTODOPage('$_TITLE - Create'),
        ),
        NavigationRoute.EDIT_TODO: (context) => ChangeNotifierProvider(
          create: (context) => CreateTODOModel(),
          child: CreateTODOPage('$_TITLE - Edit'),
        ),
      },
      initialRoute: NavigationRoute.HOME,
    );
  }
}


