import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedApp extends StatelessWidget {
  final PermissionStatus notificationStatus;
  final PermissionStatus cameraStatus;
  final PermissionStatus storageStatus;
  final bool exactAlarmPermission;

  PermissionDeniedApp({
    required this.notificationStatus,
    required this.cameraStatus,
    required this.storageStatus,
    required this.exactAlarmPermission,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Permission Denied'),
        ),
        body: Center(
          child: Text(
              'Required permissions not granted. Please enable them in settings.\n\n Notification: ${notificationStatus.isGranted}\n Camera: ${cameraStatus.isGranted}\n Exact Alarm: $exactAlarmPermission'),
        ),
      ),
    );
  }
}
