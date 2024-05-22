import 'package:flutter/material.dart';
import 'package:dookie_controls/imports.dart';
import 'package:dookie_controls/database.dart';
import 'package:dookie_controls/skin_shop/shop_data.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

DookieSave dookieBaseSave(int userId) {
  return DookieSave(
      id: userId,
      dookieAmount: 0,
      dookiesPerSecond: 0,
      dookieMultiplier: 1,
      upgrades: [
        DookieUpgradeConnection(
            upgrade: dookieUpgrades[1]!,
            saveId: userId,
            amount: 0,
            amountGenerated: 0),
        DookieUpgradeConnection(
            upgrade: dookieUpgrades[2]!,
            saveId: userId,
            amount: 0,
            amountGenerated: 0),
        DookieUpgradeConnection(
            upgrade: dookieUpgrades[3]!,
            saveId: userId,
            amount: 0,
            amountGenerated: 0),
        DookieUpgradeConnection(
            upgrade: dookieUpgrades[4]!,
            saveId: userId,
            amount: 0,
            amountGenerated: 0),
        DookieUpgradeConnection(
            upgrade: dookieUpgrades[5]!,
            saveId: userId,
            amount: 0,
            amountGenerated: 0),
        DookieUpgradeConnection(
            upgrade: dookieUpgrades[6]!,
            saveId: userId,
            amount: 0,
            amountGenerated: 0),
      ],
      currentIncrement: 0);
}

class DookieNotifier extends ChangeNotifier {
  late ColorScheme colorScheme;
  late Future<List<SkinShopData>> skinShopDataFuture;
  User? selectedUser;

  Timer? _dookieTimer;
  Timer? _autoSaveTimer;
  bool isTimerRunning = false;
  Map<int, User> users = {};

  BluetoothDevice? connectedDevice;
  BluetoothConnection? connection;
  bool isConnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;
  String serverName = '';

  JsonDatabase jsonDatabase = JsonDatabase();

  Future<String> readUsers() async {
    users = await jsonDatabase.readDatabase();
    notifyListeners();
    return 'done';
  }

  Future<void> writeUsers() async {
    await jsonDatabase.writeDatabase(data: users);
  }

  Future<void> saveUser() async {
    if (selectedUser != null) {
      users[selectedUser!.id] = selectedUser!;
      await writeUsers();
    }
  }

  void init(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
  }

  void startTimer() {
    _dookieTimer?.cancel();
    debugPrint('Timer started');
    if (selectedUser != null) {
      isTimerRunning = true;
      _dookieTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        selectedUser!.dookieSave.generateUpgradeDookies();
        notifyListeners();
      });
      _autoSaveTimer =
          Timer.periodic(const Duration(seconds: 30), (timer) async {
        await saveUser();
      });
    }
  }

  void stopTimer() {
    debugPrint('Timer stopped');
    _dookieTimer?.cancel();
    _autoSaveTimer?.cancel();
    _dookieTimer = null;
    _autoSaveTimer = null;
    isTimerRunning = false;
  }

  void selectUser(User? user) {
    selectedUser = user;
    notifyListeners();
  }

  void logout() {
    saveUser();
    selectedUser = null;
    isConnected ? connection?.finish() : null;
    isConnecting = false;
    isDisconnecting = false;
    connectedDevice = null;
    connection = null;
    serverName = '';
    stopTimer();
    notifyListeners();
  }

  void addUser(
      {required String name,
      required String lastName,
      required CarBrand carBrand}) {
    late int userId;
    if (users.isEmpty) {
      userId = 0;
    } else {
      userId = users.keys.reduce(max) + 1;
    }
    users[userId] = User(
        id: userId,
        name: name,
        lastName: lastName,
        carBrand: carBrand,
        dookieSave: dookieBaseSave(userId));
    writeUsers();
    notifyListeners();
  }

  void saveUsers() {
    writeUsers();
  }

  void removeUser(int userId) {
    users.remove(userId);
    writeUsers();
    notifyListeners();
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    int index = buffer.indexOf(13);
    if (~index != 0) {
    } else {}
  }

  void connectToDevice(BluetoothDevice device) async {
    if (device == connectedDevice) {
      return;
    }
    connectedDevice = device;
    serverName = device.name ?? "Unknown";

    BluetoothConnection.toAddress(device.address).then((connection) {
      debugPrint('Connected to the device');
      this.connection = connection;
      isConnecting = false;
      isDisconnecting = false;

      connection.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          debugPrint('Disconnecting locally!');
        } else {
          debugPrint('Disconnected remotely!');
        }
      });
    }).catchError((error) {
      debugPrint('Cannot connect, exception occured');
      debugPrint(error);
    });

    notifyListeners();
  }

  void disconnectFromDevice() {
    if (isConnecting) {
      isConnecting = false;
      connection?.finish();
      connectedDevice = null;
      notifyListeners();
      return;
    }
    isDisconnecting = true;
    connection?.finish();
    connectedDevice = null;
    notifyListeners();
  }
}
