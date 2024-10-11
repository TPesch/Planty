import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:windows_notification/windows_notification.dart';
import 'package:windows_notification/notification_message.dart';
import '../models/plant.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

WindowsNotification winNotifyPlugin = WindowsNotification(
  applicationId:
      r"{D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}\WindowsPowerShell\v1.0\powershell.exe",
);

void sendPlantNotificationService(Plant plant) async {
  if (!kIsWeb && Platform.isAndroid) {
    BigPictureStyleInformation? bigPictureStyleInformation;

    if (plant.photoPath != null) {
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(plant.photoPath!),
        contentTitle: 'Water your plant!',
        summaryText: 'Time to water ${plant.name}!',
      );
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.show(
        plant.hashCode,
        'Water your plant!',
        'Time to water ${plant.name}!',
        platformChannelSpecifics,
      );
      debugPrint("Notification for ${plant.name} sent");
    } catch (e) {
      debugPrint("Error sending notification for ${plant.name}: $e");
    }
  }
}

void sendWindowsPlantNotificationService(Plant plant) {
  String imagePath =
      plant.photoPath != null ? 'file:///${plant.photoPath}' : '';
  String template = '''
    <toast launch="action=viewPlant&amp;plantId=${plant.id}" scenario="reminder">
      <visual>
        <binding template="ToastGeneric">
          <text>Water your plant!</text>
          <text>Time to water ${plant.name}!</text>
          ${imagePath.isNotEmpty ? '<image src="$imagePath" placement="appLogoOverride" hint-crop="circle"/>' : ''}
        </binding>
      </visual>
      <actions>
        <input id="snoozeTime" type="selection" defaultInput="15">
          <selection id="1" content="1 minute"/>
          <selection id="15" content="15 minutes"/>
          <selection id="60" content="1 hour"/>
          <selection id="240" content="4 hours"/>
          <selection id="1440" content="1 day"/>
        </input>
        <action
          activationType="system"
          arguments="snooze"
          hint-inputId="snoozeTime"
          content="Snooze"/>
        <action
          activationType="system"
          arguments="dismiss"
          content="Dismiss"/>
      </actions>
    </toast>''';

  NotificationMessage message = NotificationMessage.fromCustomTemplate(
    plant.id,
    group: "plant_notifications",
  );
  winNotifyPlugin.showNotificationCustomTemplate(message, template);
}
