// pages/test_notification_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plant_model.dart';
import '../providers/theme_provider.dart';

class TestNotificationPage extends StatefulWidget {
  @override
  TestNotificationPageState createState() => TestNotificationPageState();
}

class TestNotificationPageState extends State<TestNotificationPage> {
  double _hours = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Set Timer for Test Notification (hours):'),
        Slider(
          value: _hours,
          min: 0,
          max: 24,
          divisions: 24,
          label: _hours.round().toString(),
          onChanged: (double value) {
            setState(() {
              _hours = value;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (Platform.isAndroid) {
              Provider.of<PlantModel>(context, listen: false)
                  .sendTestNotification(_hours.round());
            } else if (Platform.isWindows) {
              Provider.of<PlantModel>(context, listen: false)
                  .sendTestWindowsNotification(_hours.round());
            }
          },
          child: Text('Send Test Notification'),
        ),
        SizedBox(height: 20),
        Text('Toggle Dark Mode:'),
        Switch(
          value: themeProvider.themeMode == ThemeMode.dark,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
        ),
      ],
    );
  }
}
