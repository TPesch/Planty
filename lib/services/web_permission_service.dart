// ignore_for_file: unnecessary_null_comparison, avoid_web_libraries_in_flutter, unused_import

import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'permission_service.dart';
import 'notification_service.dart';
import 'package:plantapp/main.dart';

/// Requests necessary permissions for the web.
Future<void> requestWebPermissions() async {
  await requestGeolocationPermission();
  await requestNotificationPermission();
  await requestCameraAndMicrophonePermission();
}

/// Requests geolocation permission.
Future<void> requestGeolocationPermission() async {
  if (kIsWeb && html.window.navigator.geolocation != null) {
    html.window.navigator.geolocation.getCurrentPosition();
  } else {
    print('Geolocation is not supported by this browser.');
  }
}

/// Requests notification permission.
Future<void> requestNotificationPermission() async {
  if (kIsWeb && html.Notification != null) {
    final permission = await html.Notification.requestPermission();
    if (permission == 'granted') {
      print('Notification permission granted.');
    } else {
      print('Notification permission denied.');
    }
  } else {
    print('Notifications are not supported by this browser.');
  }
}

/// Requests camera and microphone permissions.
Future<void> requestCameraAndMicrophonePermission() async {
  try {
    if (kIsWeb) {
      await html.window.navigator.mediaDevices!
          .getUserMedia({'video': true, 'audio': true});
      print('Camera and microphone permission granted.');
    }
  } catch (e) {
    print('Camera and microphone permission denied: $e');
  }
}
