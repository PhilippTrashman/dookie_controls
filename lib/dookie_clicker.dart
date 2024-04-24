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

  bool adsEnabled() {
    return dookieNotifier.selectedUser!.carBrand.id == 1;
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    dookieNotifier = Provider.of<DookieNotifier>(context);
    return adsEnabled() ? adView() : clickerView();
  }

  Row adView() {
    return Row(
      children: [
        verticalBanner(),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              const Expanded(child: Ads(verticalAd: false)),
              Expanded(flex: 5, child: clickerView()),
              const Expanded(child: Ads(verticalAd: false)),
            ],
          ),
        ),
        verticalBanner(),
      ],
    );
  }

  Column verticalBanner() {
    return const Column(
      children: [
        Expanded(child: Ads(verticalAd: true)),
        Expanded(child: Ads(verticalAd: true)),
        Expanded(child: Ads(verticalAd: true)),
      ],
    );
  }

  Widget clickerView() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool vertical = height > width;
        int crossAxisCount = vertical ? width ~/ 125 : width ~/ 150;
        int itemCount = crossAxisCount > 0 ? crossAxisCount : 1;
        List<Widget> children = [
          Expanded(
            flex: 1,
            child: clickButton(),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: itemCount,
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
            ),
          ),
        ];

        if (vertical) {
          return Column(
            children: children,
          );
        }
        return Row(
          children: children,
        );
      },
    );
  }

  Center clickButton() {
    return Center(
      child: Column(
        children: [
          const Text("Dookie Clicker"),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  if (dookieNotifier.selectedUser != null) {
                    dookieNotifier.selectedUser!.dookieSave.dookieAmount += 1;
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
      ),
    );
  }

  Widget upgradeButton(
      {required DookieUpgradeConnection upgrade,
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
          "${upgrade.upgrade.name}\n${upgrade.priceString} d's\n${upgrade.amount} owned",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
