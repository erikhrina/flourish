import 'package:objectbox/objectbox.dart';

@Entity()
class PlantModel {
  @Id(assignable: true)
  final int id;
  final String latin;
  final String family;
  final String name;
  final String category;
  final int tempMax;
  final int tempMin;
  final String idealLight;
  final String toleratedLight;
  final String watering;
  bool saved;
  bool recent;
  String? lastWatered;

  PlantModel({
    required this.id,
    required this.latin,
    required this.family,
    required this.name,
    required this.category,
    required this.tempMax,
    required this.tempMin,
    required this.idealLight,
    required this.toleratedLight,
    required this.watering,
    required this.saved,
    required this.recent,
    required this.lastWatered,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'],
      latin: json['latin'],
      family: json['family'],
      name: json['common'][0],
      category: json['category'],
      tempMax: json['tempmax']['celsius'],
      tempMin: json['tempmin']['celsius'],
      idealLight: json['ideallight'],
      toleratedLight: json['toleratedlight'],
      watering: json['watering'],
      saved: json['saved'] ?? false,
      recent: json['recent'] ?? false,
      lastWatered: json['lastwatered'],
    );
  }
}
