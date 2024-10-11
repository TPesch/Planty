// pages/plant_detail_page.dart

// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/plant_model.dart';
import '../models/plant.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlantDetailPage extends StatefulWidget {
  final Plant plant;

  PlantDetailPage({required this.plant});

  @override
  _PlantDetailPageState createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _dateOfPlantingController;
  late TextEditingController _delayController;
  String _selectedUnit = 'seconds';
  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _speciesController = TextEditingController(text: widget.plant.species);
    _dateOfPlantingController = TextEditingController(
        text: widget.plant.dateOfPlanting.toString().split(' ')[0]);
    _delayController = TextEditingController(
        text: widget.plant.wateringDelay.inSeconds.toString());
    if (widget.plant.wateringDelay.inSeconds % 86400 == 0) {
      _selectedUnit = 'days';
      _delayController.text =
          (widget.plant.wateringDelay.inSeconds ~/ 86400).toString();
    } else if (widget.plant.wateringDelay.inSeconds % 3600 == 0) {
      _selectedUnit = 'hours';
      _delayController.text =
          (widget.plant.wateringDelay.inSeconds ~/ 3600).toString();
    } else if (widget.plant.wateringDelay.inSeconds % 60 == 0) {
      _selectedUnit = 'minutes';
      _delayController.text =
          (widget.plant.wateringDelay.inSeconds ~/ 60).toString();
    }
    if (widget.plant.photoPath != null) {
      _image = File(widget.plant.photoPath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _dateOfPlantingController.dispose();
    _delayController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera &&
        (kIsWeb || Platform.isWindows || Platform.isLinux)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera not supported on this platform.')),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _updatePlant() {
    widget.plant.name = _nameController.text;
    widget.plant.species = _speciesController.text;
    widget.plant.dateOfPlanting =
        DateTime.tryParse(_dateOfPlantingController.text) ?? DateTime.now();
    widget.plant.photoPath = _image?.path;

    int delay = int.tryParse(_delayController.text) ?? 1;
    if (_selectedUnit == 'seconds') {
      widget.plant.wateringDelay = Duration(seconds: delay);
    } else if (_selectedUnit == 'minutes') {
      widget.plant.wateringDelay = Duration(minutes: delay);
    } else if (_selectedUnit == 'hours') {
      widget.plant.wateringDelay = Duration(hours: delay);
    } else if (_selectedUnit == 'days') {
      widget.plant.wateringDelay = Duration(days: delay);
    }

    Provider.of<PlantModel>(context, listen: false).updatePlant(widget.plant);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.plant.dateOfPlanting,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.plant.dateOfPlanting) {
      setState(() {
        _dateOfPlantingController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit Plant'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Plant Name'),
              ),
              TextField(
                controller: _speciesController,
                decoration: InputDecoration(labelText: 'Species'),
              ),
              TextFormField(
                controller: _dateOfPlantingController,
                decoration: InputDecoration(
                  labelText: 'Date of Planting',
                  hintText: 'yyyy-MM-dd',
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _delayController,
                decoration: InputDecoration(labelText: 'Watering Delay'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _selectedUnit,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUnit = newValue!;
                  });
                },
                items: <String>['seconds', 'minutes', 'hours', 'days']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Capture Image'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Select Image'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePlant,
                child: Text('Update Plant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
