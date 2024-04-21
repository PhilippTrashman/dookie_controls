import 'package:flutter/material.dart';
import 'package:dookie_controls/imports.dart';
import 'dart:async';
import 'dart:math';

class IncrementToString {
  String name;
  num value;
  String abbreviation;

  IncrementToString(this.name, this.value, this.abbreviation);
}

final Map<int, IncrementToString> increments = generateIncrements();

Map<int, IncrementToString> generateIncrements() {
  final Map<int, IncrementToString> increments = {};
  final List<String> names = [
    "Thousand",
    "Million",
    "Billion",
    "Trillion",
    "Quadrillion",
    "Quintillion",
    "Sextillion",
    "Septillion",
    "Octillion",
    "Nonillion",
    "Decillion",
    "Undecillion",
    "Duodecillion",
    "Tredecillion",
    "Quattuordecillion",
    "Quindecillion",
    "Sexdecillion",
    "Septendecillion",
    "Octodecillion",
    "Novemdecillion",
    "Vigintillion",
    "Unvigintillion",
    "Duovigintillion",
    "Tresvigintillion",
    "Quattuorvigintillion",
    "Quinquavigintillion",
    "Sesvigintillion",
    "Septemvigintillion",
    "Octovigintillion",
    "Novemvigintillion",
    "Trigintillion",
    "Untrigintillion",
    "Duotrigintillion",
    "Trestrigintillion",
    "Quattuortrigintillion",
    "Quinquatrigintillion",
    "Sestrigintillion",
    "Septentrigintillion",
    "Octotrigintillion",
    "Noventrigintillion",
    "Quadragintillion"
  ];
  final List<String> abbreviations = [
    "K",
    "M",
    "B",
    "T",
    "Qa",
    "Qi",
    "Sx",
    "Sp",
    "O",
    "N",
    "D",
    "UD",
    "DD",
    "TD",
    "QaD",
    "QiD",
    "SxD",
    "SpD",
    "OD",
    "ND",
    "V",
    "UV",
    "DV",
    "TV",
    "QaV",
    "QiV",
    "SxV",
    "SpV",
    "OV",
    "NV",
    "Tg",
    "UTg",
    "DTg",
    "TTg",
    "QaTg",
    "QiTg",
    "SxTg",
    "SpTg",
    "OTg",
    "NTg",
    "Qd"
  ];
  for (int i = 0; i < names.length; i++) {
    increments[i + 1] =
        IncrementToString(names[i], pow(1000, i + 1), abbreviations[i]);
  }
  return increments;
}

class DookieUpgrade {
  final String name;
  final double _price;
  final double dookiesPerSecond;
  int amount;
  double amountGenerated;

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

  String get priceString {
    double price = this.price;
    int increment = 0;
    while (price >= 1000 && increment < increments.length) {
      price /= 1000;
      increment++;
    }
    return "${price.toStringAsFixed(2)} ${increments[increment]?.abbreviation ?? ""}";
  }

  double generateDookies() {
    return dookiesPerSecond * amount;
  }
}

class DookierStorage {
  double dookieAmount;
  double dookiesPerSecond;
  double dookieMultiplier;
  List<DookieUpgrade> upgrades;
  int currentIncrement;

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
      amount += upgrade.generateDookies();
      upgrade.amountGenerated += upgrade.generateDookies();
    }
    dookieAmount += amount;
  }

  String getDookieAmount() {
    if (dookieAmount < 1000) {
      return dookieAmount.toStringAsFixed(1);
    }
    while (dookieAmount >= 1000) {
      dookieAmount /= 1000;
      currentIncrement++;
    }
    return "${dookieAmount.toStringAsFixed(2)} ${increments[currentIncrement]?.abbreviation ?? ""}";
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

  Timer? _dookieTimer;
  bool isTimerRunning = false;

  DookieNotifier() {
    dookierStorage.dookieAmount = dookieAmount;
    dookierStorage.dookiesPerSecond = dookiesPerSecond;
    dookierStorage.dookieMultiplier = dookieMultiplier;
  }

  static List users = [
    User(name: "John", lastName: "Doe", carBrand: carBrands[1]!),
    User(name: "Jane", lastName: "Doe", carBrand: carBrands[2]!),
    User(name: "Fort", lastName: "Nite", carBrand: carBrands[3]!),
  ];
  void init(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
  }

  void startTimer() {
    _dookieTimer?.cancel();
    debugPrint('Timer started');
    isTimerRunning = true;
    _dookieTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      dookierStorage.generateUpgradeDookies();
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
}
