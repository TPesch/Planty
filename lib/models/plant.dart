// models/plant.dart
import 'dart:async';

/// The Plant class represents a plant with various properties and methods.
class Plant {
  String id;
  String name;
  String species;
  DateTime dateOfPlanting;
  bool hasBeenWatered;
  String? photoPath;
  Timer? wateringTimer;
  Duration wateringDelay;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.dateOfPlanting,
    this.hasBeenWatered = false,
    this.photoPath,
    this.wateringTimer,
    this.wateringDelay = const Duration(days: 1),
  });

  /// Converts the Plant object to a map for JSON encoding.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'dateOfPlanting': dateOfPlanting.toIso8601String(),
      'hasBeenWatered': hasBeenWatered,
      'photoPath': photoPath,
      'wateringDelay': wateringDelay.inSeconds,
    };
  }

  /// Creates a Plant object from a map (JSON decoding).
  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      name: map['name'],
      species: map['species'],
      dateOfPlanting: DateTime.parse(map['dateOfPlanting']),
      hasBeenWatered: map['hasBeenWatered'] ?? false,
      photoPath: map['photoPath'],
      wateringDelay: Duration(seconds: map['wateringDelay'] ?? 86400),
    );
  }
}
