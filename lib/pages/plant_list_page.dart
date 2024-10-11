// pages/plant_list_page.dart
// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plant_model.dart';
import 'plant_detail_page.dart';

class PlantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant List'),
      ),
      body: Consumer<PlantModel>(
        builder: (context, plantModel, child) {
          if (plantModel.plants.isEmpty) {
            return Center(
              child: Text('No plants added yet.'),
            );
          }
          return Stack(
            children: [
              GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: plantModel.plants.length,
                itemBuilder: (context, index) {
                  final plant = plantModel.plants[index];
                  return GestureDetector(
                    onTap: () {
                      plantModel.toggleWatered(plant);
                    },
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetailPage(plant: plant),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: plant.photoPath != null
                              ? Image.file(
                                  File(plant.photoPath!),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.green,
                                  child: Icon(
                                    Icons.local_florist,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: plant.hasBeenWatered
                                    ? Colors.blue
                                    : Colors.orange,
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (!plantModel.allPlantsWatered())
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      plantModel.waterAllPlants();
                    },
                    child: Text('Water All Plants'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
