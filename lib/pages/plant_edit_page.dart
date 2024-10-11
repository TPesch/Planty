// pages/plant_edit_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import '../models/plant.dart';
import '../providers/plant_model.dart';
import 'plant_detail_page.dart';


/// The PlantEditPage allows users to edit existing plants.
class PlantEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var plants = context.watch<PlantModel>().plants;
    if (plants.isEmpty) {
      return Center(child: Text('No plants to edit.'));
    }

    return ListView.builder(
      itemCount: plants.length,
      itemBuilder: (context, index) {
        var plant = plants[index];
        return ListTile(
          title: Text(plant.name),
          subtitle: Text(
              'Species: ${plant.species}, Date Planted: ${plant.dateOfPlanting.toString().split(' ')[0]}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetailPage(plant: plant),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Provider.of<PlantModel>(context, listen: false)
                      .removePlant(plant);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
