import 'package:flutter/material.dart';
import 'package:dookie_controls/imports.dart';
import 'package:dookie_controls/database.dart';
import 'dart:async';
import 'dart:math';

DookieSave dookieBaseSave = DookieSave(
    dookieAmount: 0,
    dookiesPerSecond: 0,
    dookieMultiplier: 1,
    upgrades: [
      DookieUpgrade(
          name: "Protein",
          price: 100,
          dookiesPerSecond: 1,
          amount: 0,
          amountGenerated: 0),
      DookieUpgrade(
          name: "Beer",
          price: 1100,
          dookiesPerSecond: 8,
          amount: 0,
          amountGenerated: 0),
      DookieUpgrade(
          name: "Xanax",
          price: 12000,
          dookiesPerSecond: 47,
          amount: 0,
          amountGenerated: 0),
      DookieUpgrade(
          name: "Benzos",
          price: 1400000,
          dookiesPerSecond: 1400,
          amount: 0,
          amountGenerated: 0),
      DookieUpgrade(
          name: "Benaudryl",
          price: 20000000,
          dookiesPerSecond: 7800,
          amount: 0,
          amountGenerated: 0),
      DookieUpgrade(
          name: "Fentanyl",
          price: 330000000,
          dookiesPerSecond: 44000,
          amount: 0,
          amountGenerated: 0),
    ],
    currentIncrement: 0);

class DookieNotifier extends ChangeNotifier {
  late ColorScheme colorScheme;
  User? selectedUser;

  Timer? _dookieTimer;
  bool isTimerRunning = false;
  Map<int, User> users = {};

  JsonDatabase jsonDatabase = JsonDatabase();

  Future<void> readUsers() async {
    users = await jsonDatabase.readDatabase();
    notifyListeners();
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
    isTimerRunning = true;
    _dookieTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      dookieBaseSave.generateUpgradeDookies();
      notifyListeners();
    });
  }

  void stopTimer() {
    debugPrint('Timer stopped');
    _dookieTimer?.cancel();
    _dookieTimer = null;
    isTimerRunning = false;
  }

  void selectUser(User? user) {
    selectedUser = user;
    notifyListeners();
  }

  void logout() {
    selectedUser = null;
    stopTimer();
    notifyListeners();
  }

  void addUser(
      {required String name,
      required String lastName,
      required CarBrand carBrand}) {
    if (users.isEmpty) {
      users[0] = User(
          id: 0,
          name: name,
          lastName: lastName,
          carBrand: carBrand,
          dookieSave: dookieBaseSave);
    } else {
      users[users.keys.reduce(max) + 1] = User(
          id: users.keys.reduce(max) + 1,
          name: name,
          lastName: lastName,
          carBrand: carBrand,
          dookieSave: dookieBaseSave);
    }
    notifyListeners();
  }
}
