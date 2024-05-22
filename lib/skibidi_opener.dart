import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:dookie_controls/dookie_notifier.dart';
import 'package:dookie_controls/skin_shop/shop_data.dart';

class SkibidiOpener extends StatefulWidget {
  const SkibidiOpener({super.key});

  @override
  State<SkibidiOpener> createState() => _SkibidiOpenerState();
}

class _SkibidiOpenerState extends State<SkibidiOpener> {
  late DookieNotifier dn;
  late ColorScheme colorScheme;
  late Future<List<SkinShopData>> _skinShopDataFuture;
  bool _showGacha = false;
  bool _gachaRunning = false;
  bool _gachaDone = false;
  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();
    _skinShopDataFuture = loadAssetImages();
  }

  @override
  Widget build(BuildContext context) {
    dn = Provider.of<DookieNotifier>(context);
    colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _skinShopDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return mainPage(context, snapshot);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Column mainPage(
      BuildContext context, AsyncSnapshot<List<SkinShopData>> snapshot) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child:
                    Text('Dookies ${dn.selectedUser!.dookieSave.dookieAmount}'),
              ),
            ),
          ),
        ),
        const Expanded(
            child:
                Center(child: Text('Rewards', style: TextStyle(fontSize: 24)))),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                    ),
                    child: const Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Rewards will be collected on full release'),
                        Text('獎勵將在完全發佈時收取')
                      ],
                    ))),
                if (_showGacha) Center(child: gachaShop(snapshot))
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return buyMessage(context, snapshot);
                      });
                },
                child: const Text('Open Case'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<SkinShopData> getGachaPull(AsyncSnapshot<List<SkinShopData>> snapshot) {
    final rng = Random();
    final pull = <SkinShopData>[];
    for (var i = 0; i < 10; i++) {
      pull.add(snapshot.data![rng.nextInt(snapshot.data!.length)]);
    }
    return pull;
  }

  void buttonLogic(BuildContext context, bool isChinese,
      AsyncSnapshot<List<SkinShopData>> snapshot) {
    Navigator.of(context).pop();
    _images = getGachaPull(snapshot);
    for (final image in _images) {
      debugPrint(image.name);
    }
    _showGacha = true;
    _imageIndex = 0;
  }

  late List<SkinShopData> _images;
  late Timer _gachaTimer;

  void _switchImage() {
    setState(() {
      debugPrint('switching image');
      if (_gachaTimer.tick == 10) {
        _gachaTimer.cancel();
        _gachaDone = true;
      }
      if (_imageIndex < 9) {
        _imageIndex = (_imageIndex + 1);
      }
    });
  }

  Widget gachaShop(AsyncSnapshot<List<SkinShopData>> snapshot) {
    return GestureDetector(
        onTap: () {
          debugPrint("start animation");
        },
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Image.asset(
                _images[_imageIndex].imagePath,
                key: const ValueKey('gacha_shop'),
                fit: BoxFit.cover,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_gachaDone) {
                  _gachaDone = false;
                  _gachaRunning = false;
                } else {
                  debugPrint("start gacha");
                  _gachaTimer = Timer.periodic(
                      const Duration(milliseconds: 500), (timer) {
                    _switchImage();
                  });
                  _gachaRunning = true;
                }
              },
              child: Text(_gachaRunning ? 'Stop' : 'Start'),
            )
          ],
        ));
  }

  Widget buyMessage(
      BuildContext context, AsyncSnapshot<List<SkinShopData>> snapshot) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 300,
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Pay 10 Dookies to open the case?'),
                    Text('支付 10 Dookies 即可開啟箱子?')
                  ],
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          buttonLogic(context, false, snapshot);
                        },
                        child: const Text('Yes'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          buttonLogic(context, true, snapshot);
                        },
                        child: const Text('是的'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IgnorePointer(
              child: Image.asset(
                'assets/images/chinese_thumbs_up.gif',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
