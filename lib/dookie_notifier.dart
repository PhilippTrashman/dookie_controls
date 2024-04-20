import 'package:flutter/material.dart';
import 'package:dookie_controls/imports.dart';
import 'dart:async';
import 'dart:isolate';

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

  Future<void> generateDookies() async {
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

  DookierStorage(
      {required this.dookieAmount,
      required this.dookiesPerSecond,
      required this.dookieMultiplier,
      required this.upgrades,
      required this.currentIncrement});

  void incrementDookieAmount() {
    dookieAmount += 1 * dookieMultiplier;
  }

  void generateUpgradeDookies() {
    double amount = 0;
    for (DookieUpgrade upgrade in upgrades) {
      upgrade.generateDookies();
      amount += upgrade.amountGenerated;
    }
    dookieAmount += amount;
  }
}

class DookieNotifier extends ChangeNotifier {
  late ColorScheme colorScheme;
  User? selectedUser;
  double dookieAmount = 0;
  double dookieMultiplier = 1;
  double dookiesPerSecond = 0;

  DookierStorage dookierStorage = DookierStorage(
      dookieAmount: 0,
      dookiesPerSecond: 0,
      dookieMultiplier: 0,
      upgrades: [
        DookieUpgrade(
            name: "Protein",
            price: 10,
            dookiesPerSecond: 1 * 60,
            amount: 0,
            amountGenerated: 0),
        DookieUpgrade(
            name: "Beer",
            price: 50,
            dookiesPerSecond: 3 * 60,
            amount: 0,
            amountGenerated: 0),
        DookieUpgrade(
            name: "Xanax",
            price: 100,
            dookiesPerSecond: 5 * 60,
            amount: 0,
            amountGenerated: 0),
        DookieUpgrade(
            name: "Benzos",
            price: 200,
            dookiesPerSecond: 10 * 60,
            amount: 0,
            amountGenerated: 0),
        DookieUpgrade(
            name: "Benaudryl",
            price: 250,
            dookiesPerSecond: 13 * 60,
            amount: 0,
            amountGenerated: 0),
        DookieUpgrade(
            name: "Fentanyl",
            price: 300,
            dookiesPerSecond: 15 * 60,
            amount: 0,
            amountGenerated: 0),
      ],
      currentIncrement: 0);

  Timer? _dookieTimer;

  DookieNotifier() {
    dookierStorage.dookieAmount = dookieAmount;
    dookierStorage.dookiesPerSecond = dookiesPerSecond;
    dookierStorage.dookieMultiplier = dookieMultiplier;
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

  void startTimer() {
    _dookieTimer?.cancel();
    debugPrint('Timer started');
    _dookieTimer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      dookierStorage.generateUpgradeDookies();
      debugPrint('${dookierStorage.dookieAmount}');
      notifyListeners();
    });
  }

  void stopTimer() {
    _dookieTimer?.cancel();
    _dookieTimer = null;
  }

  void selectUser(User? user) {
    selectedUser = user;
    notifyListeners();
  }
}
