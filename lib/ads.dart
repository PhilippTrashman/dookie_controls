import 'package:flutter/material.dart';

class Ads extends StatelessWidget {
  Ads({super.key, required this.verticalAd, required this.adIndex});

  final bool verticalAd;
  final int adIndex;

  static final List<String> horizontalAds = [
    'assets/ads/HonkHonkStarrail.jpg',
    'assets/ads/Chinese_therapy.gif',
  ];
  static final List<String> verticalAds = [
    'assets/ads/ballin.gif',
    'assets/ads/create_your_adventure.png',
    'assets/ads/Order_Up.png',
    'assets/ads/Rise_of_Burger.png',
    'assets/ads/shadow_wizard_money_gang.jpg',
    'assets/ads/elden_heroes.gif',
    'assets/ads/su_anuncio_aqui.gif',
  ];

  int get horizontalAmount => horizontalAds.length;
  int get verticalAmount => verticalAds.length;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      verticalAd
          ? verticalAds[adIndex % verticalAmount]
          : horizontalAds[adIndex % horizontalAmount],
      fit: BoxFit.cover,
    );
  }
}
