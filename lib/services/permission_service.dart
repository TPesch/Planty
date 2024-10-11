// services/permission_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

/// Requests necessary permissions for the app.
Future<bool> requestPermissions() async {
  debugPrint('Requesting notification permission...');
  PermissionStatus notificationStatus = await Permission.notification.status;
  if (!notificationStatus.isGranted) {
    notificationStatus = await Permission.notification.request();
  }
  debugPrint('Notification permission status: ${notificationStatus.isGranted}');

  debugPrint('Requesting camera permission...');
  PermissionStatus cameraStatus = await Permission.camera.status;
  if (!cameraStatus.isGranted) {
    cameraStatus = await Permission.camera.request();
  }
  debugPrint('Camera permission status: ${cameraStatus.isGranted}');

  debugPrint('Requesting storage permission...');
  PermissionStatus storageStatus = await Permission.storage.status;
  if (!storageStatus.isGranted) {
    storageStatus = await Permission.storage.request();
  }
  debugPrint('Storage permission status: ${storageStatus.isGranted}');

  bool exactAlarmPermission = await requestExactAlarmPermission();

  if (notificationStatus.isGranted &&
      cameraStatus.isGranted &&
      exactAlarmPermission) {
    debugPrint("All required permissions granted");
    return true;
  } else {
    debugPrint("Some permissions not granted");
    debugPrint(
        'Notification permission status: ${notificationStatus.isGranted}, ${cameraStatus.isGranted}, ${storageStatus.isGranted}, $exactAlarmPermission');

    exit(404);
    return false;
  }
}

/// Requests exact alarm permission if needed.
Future<bool> requestExactAlarmPermission() async {
  // ignore: no_leading_underscores_for_local_identifiers
  const MethodChannel _platform =
      MethodChannel('com.example.plantapp/exact_alarm');

  if (Platform.isAndroid &&
      (await _platform.invokeMethod('isExactAlarmPermissionNeeded')) == true) {
    try {
      debugPrint('Requesting exact alarm permission...');
      final bool result =
          await _platform.invokeMethod('requestExactAlarmPermission');
      debugPrint('Exact alarm permission result: $result');
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to request exact alarm permission: '${e.message}'.");
      return false;
    }
  }
  return true;
}

/// Shows a dialog requesting storage permission.
Future<void> showPermissionDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Storage Permission Required'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This app needs storage permission to function properly.'),
              Text('Please grant storage permission in the app settings.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Open Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
