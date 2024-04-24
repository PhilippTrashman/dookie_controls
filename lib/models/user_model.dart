import 'package:dookie_controls/models/car_brand_model.dart';
import 'package:dookie_controls/models/dookie_save_model.dart';

class User {
  final int id;
  final String name;
  final String lastName;
  final CarBrand carBrand;
  final DookieSave dookieSave;

  User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.carBrand,
      required this.dookieSave});

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'car_brand_id': carBrand.id,
      'dookie_save_id': dookieSave.id,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'car_brand': carBrand.toJson(),
      'dookie_save': dookieSave.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      carBrand: CarBrand.fromJson(json['car_brand']),
      dookieSave: DookieSave.fromJson(json['dookie_save']),
    );
  }
}
