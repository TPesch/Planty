// PlantModel class with updated notification methods

// ignore_for_file: unnecessary_import

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
// ignore: unused_import
import 'package:windows_notification/windows_notification.dart';
import 'package:windows_notification/notification_message.dart';
import '../models/plant.dart';
import '../services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlantModel extends ChangeNotifier {
  List<Plant> plants = [];
  final Uuid uuid = Uuid();

  PlantModel() {
    loadPlants();
  }

  void addPlant(Plant plant) {
    debugPrint("Adding a new plant: ${plant.name}");
    plant.id = uuid.v4();
    plants.add(plant);
    savePlants();
    schedulePlantTimer(plant);
    notifyListeners();
  }

  void removePlant(Plant plant) {
    plant.wateringTimer?.cancel();
    plants.remove(plant);
    savePlants();
    notifyListeners();
  }

  void updatePlant(Plant plant) {
    int index = plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      plants[index] = plant;
      savePlants();
      schedulePlantTimer(plant);
      notifyListeners();
    }
  }

  void toggleWatered(Plant plant) {
    int index = plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      plants[index].hasBeenWatered = !plants[index].hasBeenWatered;
      savePlants();
      schedulePlantTimer(plant);
      notifyListeners();
    }
  }

  void waterAllPlants() {
    for (var plant in plants) {
      plant.hasBeenWatered = true;
      plant.wateringTimer?.cancel();
      schedulePlantTimer(plant);
    }
    savePlants();
    notifyListeners();
  }

  void unwaterPlant(Plant plant) {
    int index = plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      plants[index].hasBeenWatered = false;
      savePlants();
      notifyListeners();
    }
  }

  Future<void> savePlants() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> plantData =
        plants.map((plant) => json.encode(plant.toMap())).toList();
    await prefs.setStringList('savedPlants', plantData);
  }

  Future<void> loadPlants() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> plantData = prefs.getStringList('savedPlants') ?? [];
    plants = plantData.map((data) => Plant.fromMap(json.decode(data))).toList();
    for (var plant in plants) {
      schedulePlantTimer(plant);
    }
    notifyListeners();
  }

  void schedulePlantTimer(Plant plant) {
    plant.wateringTimer?.cancel();
    plant.wateringTimer = Timer(plant.wateringDelay, () {
      unwaterPlant(plant);
      if (!kIsWeb && Platform.isAndroid) {
        sendPlantNotification(plant);
      }
      if (!kIsWeb && Platform.isWindows) {
        sendWindowsPlantNotification(plant);
      }
    });
  }

  void sendPlantNotification(Plant plant) {
    sendPlantNotificationService(plant);
  }

  void sendWindowsPlantNotification(Plant plant) {
    sendWindowsPlantNotificationService(plant);
  }

  void sendTestNotification(int delayInHours) {
    if (!kIsWeb && Platform.isAndroid) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      Timer(Duration(hours: delayInHours), () async {
        await flutterLocalNotificationsPlugin.show(
          0,
          'Test Notification',
          'This is a test notification to verify the system.',
          platformChannelSpecifics,
          payload: 'test notification payload',
        );
      });
    }
  }

  void sendTestWindowsNotification(int delayInHours) {
    if (!kIsWeb && Platform.isWindows) {
      Timer(Duration(hours: delayInHours), () {
        NotificationMessage message = NotificationMessage.fromCustomTemplate(
          "test_notification",
          group: "plant_notifications",
        );
        String template =
            r'''<toast launch="action=viewPlant&amp;plantId=test_notification" scenario="reminder">
        <visual>
          <binding template="ToastGeneric">
            <text>Test Notification</text>
            <text>This is a test notification for your plant app.</text>
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
          <action activationType="system" arguments="snooze" hint-inputId="snoozeTime" content="Snooze"/>
          <action activationType="system" arguments="dismiss" content="Dismiss"/>
        </actions>
      </toast>''';

        winNotifyPlugin.showNotificationCustomTemplate(message, template);
      });
    }
  }

  bool allPlantsWatered() {
    return plants.every((plant) => plant.hasBeenWatered);
  }
}
