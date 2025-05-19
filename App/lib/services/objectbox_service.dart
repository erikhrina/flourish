import 'dart:async';
import 'dart:convert';

import 'package:flourish/models/plant_model.dart';
import 'package:flourish/objectbox.g.dart';
import 'package:flourish/services/database_service.dart';
import 'package:flutter/services.dart';

class ObjectboxService {
  late final Store _store;
  late final Admin admin;

  ObjectboxService();

  ObjectboxService._create(this._store);

  Future<ObjectboxService> create() async {
    String database = await DatabaseService().getDbPath();
    _store = await openStore(directory: database);

    final objectboxService = ObjectboxService._create(_store);

    if (Admin.isAvailable()) {
      admin = Admin(_store);
    }
    await objectboxService._insertInitialData();

    return objectboxService;
  }

  Future<void> _insertInitialData() async {
    // Check if initial data exists, and if not, insert it
    if (_store.box<PlantModel>().isEmpty()) {
      String json = await rootBundle.loadString(
        'assets/json/house_plants_filtered.json',
      );
      List<dynamic> data = await jsonDecode(json);
      List<PlantModel> plants = [];
      for (dynamic entry in data) {
        plants.add(PlantModel.fromJson(entry));
      }
      savePlants(plants);
    }
  }

  List<PlantModel> getPlants({
    bool sortedByWater = false,
    bool sortedByRecent = false,
    Condition<PlantModel>? condition,
  }) {
    List<PlantModel> plants;

    // Query for either all plants or based on a condition
    if (condition == null) {
      plants = _store.box<PlantModel>().getAll();
    } else {
      Query<PlantModel> query = _store
          .box<PlantModel>()
          .query(
            condition,
          )
          .build();
      plants = query.find();
      query.close();
    }

    // Sort if needed
    if (sortedByWater) {
      // TODO: implement
      plants.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (sortedByRecent) {
      // TODO: implement
      plants.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else {
      plants.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    }

    return plants;
  }

  PlantModel? getPlantById(int id) {
    PlantModel? plant = _store.box<PlantModel>().get(id);
    return plant;
  }

  void savePlant(PlantModel plant) {
    _store.box<PlantModel>().put(plant);
  }

  void savePlants(List<PlantModel> plant) {
    _store.box<PlantModel>().putMany(plant);
  }

  void deletePlantById(int id) {
    _store.box<PlantModel>().remove(id);
  }

  void deleteAll() {
    _store.box<PlantModel>().removeAll();
  }
}
