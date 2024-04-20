import 'package:flutter/material.dart';
import 'package:dookie_controls/imports.dart';
import 'dart:async';

class DookieUpgrade {
  final String name;
  final double _price;
  final int dookiesPerSecond;
  int amount;
  int amountGenerated;

  DookieUpgrade(
      {required this.name,
      required double price,
      required this.dookiesPerSecond,
      required this.amount,
      required this.amountGenerated})
      : _price = price;

  double get price {
    if (amount == 0) {
      return _price;
    }
    return _price * (1.15 * amount);
  }

  void generateDookies() {
    amountGenerated += amount * dookiesPerSecond;
  }
}

class DookierStorage {
  double dookieAmount;
  double dookiesPerSecond;
  double dookieMultiplier;
  List<DookieUpgrade> upgrades;
  int currentIncrement;
  final Map<int, String> increments = {
    1: "Thousands",
    2: "Millions",
    3: "Billions",
    4: "Trillions",
    5: "Quadrillions",
    6: "Quintillions",
    7: "Sextillions",
    8: "Septillions",
    9: "Octillions",
    10: "Nonillions",
    11: "Decillions",
    12: "Undecillions",
    13: "Duodecillions",
    14: "Tredecillions",
    15: "Quattuordecillions",
    16: "Quindecillions",
  };
  Timer? _dookieTimer;

  DookierStorage(
      {required this.dookieAmount,
      required this.dookiesPerSecond,
      required this.dookieMultiplier,
      required this.upgrades,
      required this.currentIncrement});

  void _startTimer() {
    _dookieTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      dookieAmount += dookiesPerSecond;
    });
  }

  void _stopTimer() {
    _dookieTimer?.cancel();
    _dookieTimer = null;
  }
}

class DookieNotifier extends ChangeNotifier {
  late ColorScheme colorScheme;
  User? selectedUser;
  double dookieAmount = 0;
  double dookieMultiplier = 1;
  double dookiesPerSecond = 0;
  DookierStorage? dookierStorage;

  DookieNotifier() {
    dookierStorage = DookierStorage(
        dookieAmount: dookieAmount,
        dookiesPerSecond: dookiesPerSecond,
        dookieMultiplier: dookieMultiplier,
        upgrades: [
          DookieUpgrade(
              name: "Upgrade 1",
              price: 10,
              dookiesPerSecond: 1,
              amount: 0,
              amountGenerated: 0),
          DookieUpgrade(
              name: "Upgrade 2",
              price: 100,
              dookiesPerSecond: 10,
              amount: 0,
              amountGenerated: 0),
          DookieUpgrade(
              name: "Upgrade 3",
              price: 1000,
              dookiesPerSecond: 100,
              amount: 0,
              amountGenerated: 0),
          DookieUpgrade(
              name: "Upgrade 4",
              price: 10000,
              dookiesPerSecond: 1000,
              amount: 0,
              amountGenerated: 0),
          DookieUpgrade(
              name: "Upgrade 5",
              price: 100000,
              dookiesPerSecond: 10000,
              amount: 0,
              amountGenerated: 0),
        ],
        currentIncrement: 0);
    dookierStorage!._startTimer();
  }

  static CarBrand carBrand = CarBrand("Toyota", "toyota_logo.png");
  static List users = [
    User(name: "John", lastName: "Doe", carBrand: carBrand),
    User(name: "Jane", lastName: "Doe", carBrand: carBrand),
    User(name: "Fort", lastName: "Nite", carBrand: carBrand)
  ];
  void init(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
  }

  void selectUser(User? user) {
    selectedUser = user;
    notifyListeners();
  }
}
