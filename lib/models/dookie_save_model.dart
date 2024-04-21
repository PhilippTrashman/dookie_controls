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
  final int id;
  final String name;
  final double _price;
  final double dookiesPerSecond;

  DookieUpgrade({
    required this.id,
    required this.name,
    required double price,
    required this.dookiesPerSecond,
  }) : _price = price;

  double get price {
    return _price;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': _price,
      'dookiesPerSecond': dookiesPerSecond,
    };
  }

  factory DookieUpgrade.fromJson(Map<String, dynamic> json) {
    return DookieUpgrade(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      dookiesPerSecond: json['dookiesPerSecond'],
    );
  }
}

Map<int, DookieUpgrade> dookieUpgrades = {
  1: DookieUpgrade(id: 1, name: "Protein", price: 100, dookiesPerSecond: 1),
  2: DookieUpgrade(id: 2, name: "Beer", price: 1100, dookiesPerSecond: 8),
  3: DookieUpgrade(id: 3, name: "Xanax", price: 12000, dookiesPerSecond: 47),
  4: DookieUpgrade(
      id: 4, name: "Benzos", price: 1400000, dookiesPerSecond: 1400),
  5: DookieUpgrade(
      id: 5, name: "Benaudryl", price: 20000000, dookiesPerSecond: 7800),
  6: DookieUpgrade(
      id: 6, name: "Fentanyl", price: 330000000, dookiesPerSecond: 44000)
};

class DookieUpgradeConnection {
  final DookieUpgrade upgrade;
  final int saveId;
  double amount;
  double amountGenerated;

  DookieUpgradeConnection(
      {required this.upgrade,
      required this.saveId,
      required this.amount,
      required this.amountGenerated});

  double get price {
    if (amount == 0) {
      return upgrade.price;
    }
    return upgrade.price * (1.15 * amount);
  }

  String get priceString {
    double price = upgrade.price;
    int increment = 0;
    while (price >= 1000 && increment < increments.length) {
      price /= 1000;
      increment++;
    }
    return "${price.toStringAsFixed(2)} ${increments[increment]?.abbreviation ?? ""}";
  }

  double generateDookies() {
    return upgrade.dookiesPerSecond * amount;
  }

  Map<String, dynamic> toJson() {
    return {
      'upgrade_id': upgrade.id,
      'saveId': saveId,
      'amount': amount,
      'amountGenerated': amountGenerated,
    };
  }

  factory DookieUpgradeConnection.fromJson(Map<String, dynamic> json) {
    return DookieUpgradeConnection(
      upgrade: dookieUpgrades[int.parse(json['upgrade_id'])]!,
      saveId: json['saveId'],
      amount: json['amount'],
      amountGenerated: json['amountGenerated'],
    );
  }
}

class DookieSave {
  int id;
  double dookieAmount;
  double dookiesPerSecond;
  double dookieMultiplier;
  List<DookieUpgradeConnection> upgrades;
  int currentIncrement;

  DookieSave(
      {required this.id,
      required this.dookieAmount,
      required this.dookiesPerSecond,
      required this.dookieMultiplier,
      required this.upgrades,
      required this.currentIncrement});

  void incrementDookieAmount() {
    dookieAmount += 1 * dookieMultiplier;
  }

  void generateUpgradeDookies() {
    double amount = 0;
    for (DookieUpgradeConnection upgrade in upgrades) {
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
      id: json['id'],
      dookieAmount: json['dookieAmount'],
      dookiesPerSecond: json['dookiesPerSecond'],
      dookieMultiplier: json['dookieMultiplier'],
      upgrades: List<DookieUpgradeConnection>.from(
          json['upgrades'].map((e) => DookieUpgradeConnection.fromJson(e))),
      currentIncrement: json['currentIncrement'],
    );
  }
}
