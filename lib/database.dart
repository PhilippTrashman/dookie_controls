import 'dart:io';
import 'dart:convert';
import 'package:dookie_controls/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class JsonDatabase {
  final _encoder = const JsonEncoder.withIndent('  ');
  final _decoder = const JsonDecoder();

  static Future<String> get _localPath async {
    final basePath = await getApplicationDocumentsDirectory();
    const databasePath = 'DoockieControls/database.gz';

    final databaseDir = Directory('${basePath.path}/$databasePath');
    if (!databaseDir.existsSync()) {
      databaseDir.createSync(recursive: true);
    }

    return databaseDir.path;
  }

  void _writeJson({required Map data, required String path}) {
    final json = _encoder.convert(data);
    final compressed = GZipCodec().encode(utf8.encode(json));

    File(path).writeAsBytesSync(compressed);
  }

  Map _readJson({required String path}) {
    final compressed = File(path).readAsBytesSync();
    final json = utf8.decode(GZipCodec().decode(compressed));
    return _decoder.convert(json);
  }

  Future<void> writeDatabase({required Map<int, User> data}) async {
    final path = await _localPath;
    final users = <String, Map<String, dynamic>>{};
    for (final key in data.keys) {
      users[key.toString()] = data[key]!.toJson();
    }

    _writeJson(data: users, path: path);
  }

  Future<Map<int, User>> readDatabase() async {
    final path = await _localPath;
    final data = _readJson(path: path);
    Map<int, User> users = {};

    for (final key in data.keys) {
      final user = User.fromJson(data[key]);
      users[int.parse(key)] = user;
    }

    return users;
  }
}
