// main.dart
// ignore_for_file: unnecessary_import, unused_import
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';
import 'pages/home_page.dart';
import 'pages/plant_input_page.dart';
import 'pages/plant_list_page.dart';
import 'pages/plant_edit_page.dart';
import 'pages/test_notification_page.dart';
import 'providers/plant_model.dart';
import 'providers/theme_provider.dart';
import '../pages/my_home_page.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

WindowsNotification _winNotifyPlugin = WindowsNotification(
    applicationId:
        r"{D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}\WindowsPowerShell\v1.0\powershell.exe");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreferences();

  if (!kIsWeb && Platform.isAndroid) {
    print('Platform: Android');
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    bool permissionsGranted = await requestPermissions();
    if (permissionsGranted) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => themeProvider),
            ChangeNotifierProvider(create: (_) => PlantModel()),
          ],
          child: MyApp(),
        ),
      );
    } else {
      runApp(PermissionDeniedApp());
    }
  } else if (!kIsWeb && Platform.isWindows) {
    print('Platform: Windows');
    _winNotifyPlugin.initNotificationCallBack((s) {
      print(s.argrument);
      print(s.userInput);
      print(s.eventType);
    });
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeProvider),
          ChangeNotifierProvider(create: (_) => PlantModel()),
        ],
        child: MyApp(),
      ),
    );
  } else {
    print('Platform: Other');
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeProvider),
          ChangeNotifierProvider(create: (_) => PlantModel()),
        ],
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Planty',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 16, 131, 16),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          home: MyHomePage(),
        );
      },
    );
  }
}

Future<bool> requestPermissions() async {
  PermissionStatus notificationStatus = await Permission.notification.status;
  if (!notificationStatus.isGranted) {
    notificationStatus = await Permission.notification.request();
  }

  PermissionStatus cameraStatus = await Permission.camera.status;
  if (!cameraStatus.isGranted) {
    cameraStatus = await Permission.camera.request();
  }

  PermissionStatus storageStatus = await Permission.storage.status;
  if (!storageStatus.isGranted) {
    storageStatus = await Permission.storage.request();
  }

  bool exactAlarmPermission = await requestExactAlarmPermission();

  return notificationStatus.isGranted &&
      cameraStatus.isGranted &&
      exactAlarmPermission;
}

Future<bool> requestExactAlarmPermission() async {
  if (Platform.isAndroid &&
      (await _platform.invokeMethod('isExactAlarmPermissionNeeded')) == true) {
    try {
      return await _platform.invokeMethod('requestExactAlarmPermission');
    } on PlatformException catch (e) {
      print("Failed to request exact alarm permission: '${e.message}'.");
      return false;
    }
  }
  return true;
}

const MethodChannel _platform =
    MethodChannel('com.example.plantapp/exact_alarm');

class PermissionDeniedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Permission Denied'),
        ),
        body: Center(
          child: Text(
              'Required permissions not granted. Please enable them in settings.'),
        ),
      ),
    );
  }
}
