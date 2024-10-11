// pages/plant_input_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/plant.dart';
import '../providers/plant_model.dart';
import 'dart:async';


/// The PlantInputPage allows users to input new plant details.
class PlantInputPage extends StatefulWidget {
  @override
  PlantInputPageState createState() => PlantInputPageState();
}

class PlantInputPageState extends State<PlantInputPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _delayController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedUnit = 'seconds';
  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
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

  /// Submits the form to add a new plant.
  void _submitForm() {
    int delay = int.tryParse(_delayController.text) ?? 1;
    Duration wateringDelay;
    if (_selectedUnit == 'seconds') {
      wateringDelay = Duration(seconds: delay);
    } else if (_selectedUnit == 'minutes') {
      wateringDelay = Duration(minutes: delay);
    } else if (_selectedUnit == 'hours') {
      wateringDelay = Duration(hours: delay);
    } else if (_selectedUnit == 'days') {
      wateringDelay = Duration(days: delay);
    } else {
      wateringDelay = Duration(seconds: delay);
    }

    final plant = Plant(
      id: '',
      name: _nameController.text,
      species: _speciesController.text,
      dateOfPlanting: _selectedDate,
      hasBeenWatered: false,
      photoPath: _image?.path,
      wateringDelay: wateringDelay,
    );
    Provider.of<PlantModel>(context, listen: false).addPlant(plant);
    _nameController.clear();
    _speciesController.clear();
    _delayController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _selectedUnit = 'seconds';
      _image = null;
    });
  }

  /// Selects the date of planting.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Plant Name',
              ),
            ),
            TextField(
              controller: _speciesController,
              decoration: InputDecoration(
                labelText: 'Species',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date of Planting',
                hintText: 'yyyy-MM-dd',
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
              controller: TextEditingController(
                text: "${_selectedDate.toLocal()}".split(' ')[0],
              ),
            ),
            TextField(
              controller: _delayController,
              decoration: InputDecoration(
                labelText: 'Watering Delay',
              ),
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
              onPressed: _submitForm,
              child: Text('Add Plant'),
            ),
          ],
        ),
      ),
    );
  }
}
