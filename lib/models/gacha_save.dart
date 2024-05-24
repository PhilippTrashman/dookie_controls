class GachaSave {
  final int id;
  final Map<int, GachaSaveObject> gachas;

  GachaSave({required this.id, required this.gachas});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gachas':
          gachas.map((key, value) => MapEntry(key.toString(), value.toJson())),
    };
  }

  factory GachaSave.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final gachas = <int, GachaSaveObject>{};
    for (final key in json['gachas'].keys) {
      gachas[int.parse(key)] = GachaSaveObject.fromJson(json['gachas'][key]);
    }
    return GachaSave(id: id, gachas: gachas);
  }

  GachaSave copyWith({
    int? id,
    Map<int, GachaSaveObject>? gachas,
  }) {
    return GachaSave(
      id: id ?? this.id,
      gachas: gachas ?? this.gachas,
    );
  }

  GachaSaveObject? getGacha(int id) {
    return gachas[id];
  }

  void addGacha(int id) {
    if (gachas.containsKey(id)) {
      gachas[id] = gachas[id]!.copyWith(amount: gachas[id]!.amount + 1);
    } else {
      gachas[id] = GachaSaveObject(id: id, amount: 1, upgradeStep: 0, level: 1);
    }
  }

  void removeGacha(int id) {
    if (gachas.containsKey(id)) {
      if (gachas[id]!.amount == 1) {
        gachas.remove(id);
      } else {
        gachas[id] = gachas[id]!.copyWith(amount: gachas[id]!.amount - 1);
      }
    }
  }

  void upgradeGacha(int id) {
    if (gachas.containsKey(id)) {
      gachas[id] =
          gachas[id]!.copyWith(upgradeStep: gachas[id]!.upgradeStep + 1);
    }
  }
}

class GachaSaveObject {
  final int id;
  int amount;
  int upgradeStep;
  int level;

  GachaSaveObject({
    required this.id,
    required this.amount,
    required this.upgradeStep,
    required this.level,
  });

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'amount': amount,
      'upgrade_step': upgradeStep,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'upgrade_step': upgradeStep,
      'level': level,
    };
  }

  factory GachaSaveObject.fromJson(Map<String, dynamic> json) {
    return GachaSaveObject(
      id: json['id'],
      amount: json['amount'],
      upgradeStep: json['upgrade_step'],
      level: json['level'],
    );
  }

  GachaSaveObject copyWith({
    int? id,
    int? amount,
    int? upgradeStep,
    int? level,
  }) {
    return GachaSaveObject(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      upgradeStep: upgradeStep ?? this.upgradeStep,
      level: level ?? this.level,
    );
  }

  @override
  String toString() {
    return 'GachaSaveObject{id: $id, amount: $amount, upgradeStep: $upgradeStep}';
  }

  void upgrade() {
    const maxUpgrade = 5;
    int amountNeeded = (upgradeStep + 1) * 2;
    amountNeeded = amountNeeded < 1 ? 1 : amountNeeded;
    if (upgradeStep < maxUpgrade && amount >= amountNeeded) {
      upgradeStep++;
      amount -= amountNeeded + 1;
    }
  }

  void levelUp() {
    if (level <= 99) {
      level++;
    }
  }
}
