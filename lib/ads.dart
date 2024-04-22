import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class Ads extends StatefulWidget {
  Ads({super.key, required this.verticalAd});

  final bool verticalAd;
  static final List<AdModel> horizontalAds = [
    AdModel(
        imageUrl: 'assets/ads/HonkHonkStarrail.jpg',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
    AdModel(
        imageUrl: 'assets/ads/Chinese_therapy.gif',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
  ];

  static final List<AdModel> verticalAds = [
    AdModel(
        imageUrl: 'assets/ads/ballin.gif',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
    AdModel(
        imageUrl: 'assets/ads/create_your_adventure.png',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
    AdModel(
        imageUrl: 'assets/ads/Order_Up.png',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
    AdModel(
        imageUrl: 'assets/ads/Rise_of_Burger.png',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
    AdModel(
        imageUrl: 'assets/ads/shadow_wizard_money_gang.jpg',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
    AdModel(
        imageUrl: 'assets/ads/elden_heroes.gif',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
    AdModel(
        imageUrl: 'assets/ads/su_anuncio_aqui.gif',
        link: 'https://www.youtube.com/watch?v=cJjl7EbfQDs'),
  ];

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  final adIndex = Random().nextInt(Ads.verticalAds.length);

  int get horizontalAmount => Ads.horizontalAds.length;

  int get verticalAmount => Ads.verticalAds.length;

  Widget adObject(AdModel ad) {
    return Container(
      // width: widget.verticalAd ? 540 : 192,
      // height: widget.verticalAd ? 192 : 540,
      child: InkWell(
        onTap: () async {
          final Uri url = Uri.parse(ad.link);
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        },
        child: Image.asset(
          ad.imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.verticalAd
        ? adObject(Ads.verticalAds[adIndex % verticalAmount])
        : adObject(Ads.horizontalAds[adIndex % horizontalAmount]);
  }
}

class AdModel {
  final String imageUrl;
  final String link;

  AdModel({required this.imageUrl, required this.link});
}
