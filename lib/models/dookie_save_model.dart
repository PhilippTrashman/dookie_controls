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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': _price,
      'dookiesPerSecond': dookiesPerSecond,
      'amount': amount,
      'amountGenerated': amountGenerated,
    };
  }

  factory DookieUpgrade.fromJson(Map<String, dynamic> json) {
    return DookieUpgrade(
      name: json['name'],
      price: json['price'],
      dookiesPerSecond: json['dookiesPerSecond'],
      amount: json['amount'],
      amountGenerated: json['amountGenerated'],
    );
  }
}

class DookieSave {
  double dookieAmount;
  double dookiesPerSecond;
  double dookieMultiplier;
  List<DookieUpgrade> upgrades;
  int currentIncrement;

  DookieSave(
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

  Map<String, dynamic> toJson() {
    return {
      'dookieAmount': dookieAmount,
      'dookiesPerSecond': dookiesPerSecond,
      'dookieMultiplier': dookieMultiplier,
      'upgrades': upgrades.map((e) => e.toJson()).toList(),
      'currentIncrement': currentIncrement,
    };
  }

  factory DookieSave.fromJson(Map<String, dynamic> json) {
    return DookieSave(
      dookieAmount: json['dookieAmount'],
      dookiesPerSecond: json['dookiesPerSecond'],
      dookieMultiplier: json['dookieMultiplier'],
      upgrades: List<DookieUpgrade>.from(
          json['upgrades'].map((e) => DookieUpgrade.fromJson(e))),
      currentIncrement: json['currentIncrement'],
    );
  }
}
