import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dookie_controls/imports.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sqflite/sqflite.dart';

class JsonDatabase {
  final _encoder = const JsonEncoder.withIndent('  ');
  final _decoder = const JsonDecoder();
  static const folderPath = 'DoockieControls';

  static Future<String> get _localPath async {
    const documentsPath = 'storage/emulated/0/Documents';
    final basePath = await getApplicationDocumentsDirectory().then((value) {
      return value.path;
    });
    const databasePath = 'DoockieControls/database.json';
    // var status = await Permission.storage.status;
    // if (status == PermissionStatus.denied) {
    //   await Permission.storage.request();
    // }
    final folderDir = Directory('$basePath/$folderPath');
    if (!folderDir.existsSync()) {
      folderDir.createSync(recursive: true);
    }
    final databaseDir = Directory('$basePath/$databasePath');

    // final resultDir = Directory('$documentsPath/$databasePath');

    return databaseDir.path;
  }

  void _writeJson({required Map data, required String path}) {
    final json = _encoder.convert(data);
    // final compressed = GZipCodec().encode(utf8.encode(json));
    // print('Writing to $path');
    // File(path).writeAsBytesSync(compressed);
    File(path).writeAsStringSync(json);
    print('Done');
  }

  Map _readJson({required String path}) {
    try {
      // final compressed = File(path).readAsBytesSync();
      // final json = utf8.decode(GZipCodec().decode(compressed));
      // return _decoder.convert(json);
      final json = File(path).readAsStringSync();
      final data = jsonDecode(json);
      return data;
    } catch (e) {
      print('Error reading file: $e');
      _writeJson(data: {}, path: path);
      return {};
    }
  }

  Future<void> writeDatabase({required Map<int, User> data}) async {
    final path = await _localPath;
    // var status = await Permission.storage.status;
    // if (status == PermissionStatus.denied) {
    //   await Permission.storage.request();
    // }
    final users = <String, Map<String, dynamic>>{};
    for (final key in data.keys) {
      users[key.toString()] = data[key]!.toJson();
    }
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    _writeJson(data: users, path: path);
  }

  Future<Map<int, User>> readDatabase() async {
    final path = await _localPath;
    final data = _readJson(path: path);
    Map<int, User> users = {};
    try {
      for (final key in data.keys) {
        final user = User.fromJson(data[key]);
        users[int.parse(key)] = user;
      }
    } catch (e) {
      debugPrint('Error reading database: $e');
    }

    return users;
  }
}

class SqfliteDatabas {
  static const String _databaseName = 'dookie_controls.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  static const String _userTable = 'users';
  static const String _carBrandTable = 'car_brands';
  static const String _dookieSaveTable = 'dookie_saves';
  static const String _dookieUpgradeTable = 'dookie_upgrades';

  static const String _userTableCreate = '''
    CREATE TABLE $_userTable (
      id INTEGER PRIMARY KEY,
      name TEXT,
      last_name TEXT,
      car_brand_id INTEGER,
      dookie_save_id INTEGER,
      FOREIGN KEY (car_brand_id) REFERENCES $_carBrandTable (id),
      FOREIGN KEY (dookie_save_id) REFERENCES $_dookieSaveTable (id)
    )
  ''';

  static const String _carBrandTableCreate = '''
    CREATE TABLE $_carBrandTable (
      id INTEGER PRIMARY KEY,
      name TEXT,
      logo TEXT
    )
  ''';

  static const String _dookieSaveTableCreate = '''
    CREATE TABLE $_dookieSaveTable (
      id INTEGER PRIMARY KEY,
      dookie_amount REAL,
      dookies_per_second REAL,
      dookie_multiplier REAL,
      current_increment INTEGER,
      upgrades TEXT
    )
  ''';

  static const String _dookieUpgradeTableCreate = '''
    CREATE TABLE $_dookieUpgradeTable IF NOT EXISTS (
      id INTEGER PRIMARY KEY,
      name TEXT,
      price REAL,
      dookies_per_second REAL,
    )
  ''';

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(_userTableCreate);
    await db.execute(_carBrandTableCreate);
    await db.execute(_dookieSaveTableCreate);
    await db.execute(_dookieUpgradeTableCreate);
  }

  static Future<void> _clearDatabase(Database db) async {
    await db.execute('DROP TABLE IF EXISTS $_userTable');
    await db.execute('DROP TABLE IF EXISTS $_carBrandTable');
    await db.execute('DROP TABLE IF EXISTS $_dookieSaveTable');
    await db.execute('DROP TABLE IF EXISTS $_dookieUpgradeTable');
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/$_databaseName';

    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> clearDatabase() async {
    final db = await database;
    await _clearDatabase(db);
  }

  static Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }

  static Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(_userTable, user.toJson());
  }
}
