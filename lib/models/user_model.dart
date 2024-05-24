import 'package:dookie_controls/models/car_brand_model.dart';
import 'package:dookie_controls/models/dookie_save_model.dart';
import 'package:dookie_controls/models/gacha_save.dart';

class User {
  final int version = 2;
  final int id;
  final String name;
  final String lastName;
  final CarBrand carBrand;
  final DookieSave dookieSave;
  final GachaSave gachaSave;

  bool devMode;
  bool isCheater;

  User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.carBrand,
      required this.dookieSave,
      required this.gachaSave,
      required this.devMode,
      required this.isCheater});

  Map<String, dynamic> toDbMap() {
    return {
      'version': version,
      'id': id,
      'name': name,
      'last_name': lastName,
      'car_brand_id': carBrand.id,
      'dookie_save_id': dookieSave.id,
      'gacha_save_id': gachaSave.id,
      'dev_mode': devMode,
      'is_cheater': isCheater,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'id': id,
      'name': name,
      'last_name': lastName,
      'car_brand': carBrand.toJson(),
      'dookie_save': dookieSave.toJson(),
      'gacha_save': gachaSave.toJson(),
      'dev_mode': devMode,
      'is_cheater': isCheater,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    int version = json['version'] ?? 0;
    if (version == 0) {
      return User(
        id: json['id'],
        name: json['name'],
        lastName: json['last_name'],
        carBrand: CarBrand.fromJson(json['car_brand']),
        dookieSave: DookieSave.fromJson(json['dookie_save']),
        gachaSave: GachaSave(id: json['id'], gachas: {}),
        devMode: false,
        isCheater: false,
      );
    }
    if (version == 1) {
      return User(
        id: json['id'],
        name: json['name'],
        lastName: json['last_name'],
        carBrand: CarBrand.fromJson(json['car_brand']),
        dookieSave: DookieSave.fromJson(json['dookie_save']),
        gachaSave: GachaSave.fromJson(json['gacha_save']),
        devMode: false,
        isCheater: false,
      );
    }
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      carBrand: CarBrand.fromJson(json['car_brand']),
      dookieSave: DookieSave.fromJson(json['dookie_save']),
      gachaSave: GachaSave.fromJson(json['gacha_save']),
      devMode: json['dev_mode'],
      isCheater: json['is_cheater'],
    );
  }
}
