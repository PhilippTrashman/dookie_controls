import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dookie_controls/dookie_notifier.dart';
import 'package:dookie_controls/models/dookie_save_model.dart';
import 'package:dookie_controls/ads.dart';

class DookieClicker extends StatefulWidget {
  const DookieClicker({super.key});

  @override
  State<DookieClicker> createState() => _DookieClickerState();
}

class _DookieClickerState extends State<DookieClicker> {
  late ColorScheme colorScheme;
  late DookieNotifier dookieNotifier;
  bool adsEnabled = true;

  int ad1 = Random().nextInt(Ads.verticalAds.length);
  int ad2 = Random().nextInt(Ads.verticalAds.length);
  int ad3 = Random().nextInt(Ads.verticalAds.length);
  int ad4 = Random().nextInt(Ads.verticalAds.length);
  int ad5 = Random().nextInt(Ads.verticalAds.length);
  int ad6 = Random().nextInt(Ads.verticalAds.length);

  int horizontalAd1 = Random().nextInt(Ads.horizontalAds.length);
  int horizontalAd2 = Random().nextInt(Ads.horizontalAds.length);

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    dookieNotifier = Provider.of<DookieNotifier>(context);
    return adsEnabled ? adView() : clickerView();
  }

  Row adView() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Ads(verticalAd: true, adIndex: ad1),
              Ads(verticalAd: true, adIndex: ad2),
              Ads(verticalAd: true, adIndex: ad3),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Ads(verticalAd: false, adIndex: horizontalAd1),
              Expanded(child: clickerView()),
              Ads(verticalAd: false, adIndex: horizontalAd2),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Ads(verticalAd: true, adIndex: ad4),
              Ads(verticalAd: true, adIndex: ad5),
              Ads(verticalAd: true, adIndex: ad6),
            ],
          ),
        ),
      ],
    );
  }

  Column clickerView() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Container(
                child: Column(
              children: [
                const Text("Dookie Clicker"),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (dookieNotifier.selectedUser != null) {
                          dookieNotifier
                              .selectedUser!.dookieSave.dookieAmount += 1;
                        }
                      });
                    },
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      color: colorScheme.onPrimaryContainer,
                    )),
                Text(
                  dookieNotifier.selectedUser != null
                      ? "${dookieNotifier.selectedUser!.dookieSave.getDookieAmount()} Dookies"
                      : "No User Selected",
                ),
              ],
            )),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
              child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: adsEnabled ? 2 : 3,
            ),
            itemCount: dookieNotifier.selectedUser != null
                ? dookieNotifier.selectedUser!.dookieSave.upgrades.length
                : 0,
            itemBuilder: (BuildContext context, int index) {
              if (dookieNotifier.selectedUser != null) {
                return upgradeButton(
                  upgrade:
                      dookieNotifier.selectedUser!.dookieSave.upgrades[index],
                  dookieNotifier: dookieNotifier,
                );
              } else {
                return const SizedBox();
              }
            },
          )),
        )
      ],
    );
  }

  Widget upgradeButton(
      {required DookieUpgrade upgrade,
      required DookieNotifier dookieNotifier}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: () {
          if (dookieNotifier.selectedUser != null) {
            if (dookieNotifier.selectedUser!.dookieSave.dookieAmount >=
                upgrade.price) {
              setState(() {
                dookieNotifier.selectedUser!.dookieSave.dookieAmount -=
                    upgrade.price;
                upgrade.amount++;
              });
            }
          }
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        child: Text(
          "${upgrade.name}\n${upgrade.priceString} d's\n${upgrade.amount} owned",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
