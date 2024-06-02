class UnlockedSkins {
  final int id;
  final List<int> unlockedSkins;
  int? lastDisplayedSkin;

  UnlockedSkins(
      {required this.id, required this.unlockedSkins, this.lastDisplayedSkin});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unlocked_skins': unlockedSkins,
      'last_displayed_skin': lastDisplayedSkin,
    };
  }

  factory UnlockedSkins.fromJson(Map<String, dynamic> json) {
    return UnlockedSkins(
      id: json['id'],
      unlockedSkins: List<int>.from(json['unlocked_skins']),
      lastDisplayedSkin: json['last_displayed_skin'],
    );
  }

  void reset() {
    unlockedSkins.clear();
    lastDisplayedSkin = null;
  }

  void unlockSkin(int skinId) {
    if (!unlockedSkins.contains(skinId)) {
      unlockedSkins.add(skinId);
    }
  }

  void lockSkin(int skinId) {
    if (unlockedSkins.contains(skinId)) {
      unlockedSkins.remove(skinId);
    }
  }

  void setLastDisplayedSkin(int skinId) {
    lastDisplayedSkin = skinId;
  }

  bool isSkinUnlocked(int skinId) {
    return unlockedSkins.contains(skinId);
  }

  void applySkin(int skinId) {
    if (isSkinUnlocked(skinId)) {
      setLastDisplayedSkin(skinId);
    }
  }
}
