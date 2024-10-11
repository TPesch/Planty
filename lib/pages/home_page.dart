import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plant_model.dart';
import '../models/plant.dart';
import 'dart:io';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var plants = context.watch<PlantModel>().plants;
    Plant? randomPlantWithPhoto;

    if (plants.isNotEmpty) {
      randomPlantWithPhoto = (plants..shuffle()).firstWhere(
        (plant) => plant.photoPath != null,
        orElse: () => plants.first,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('By: Tomas Pesch 3119912'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Planty!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (randomPlantWithPhoto != null &&
                randomPlantWithPhoto.photoPath != null)
              Image.file(
                File(randomPlantWithPhoto.photoPath!),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Icon(
                Icons.local_florist,
                size: 200,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}
