import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:dookie_controls/dookie_notifier.dart';
import 'package:dookie_controls/skin_shop/shop_data.dart';

int getTierNumber(String tier) {
  switch (tier) {
    case 'Free': // sata andagi
      return 10;
    case 'Trash': // funny Waifu
      return 9;
    case 'Common': // Bad Waifu
      return 8;
    case 'Uncommon': // normal Waifu
      return 7;
    case 'Rare': // Subpar Waifu
      return 6;
    case 'Epic': // Good Waifu
      return 5;
    case 'Legendary': // True Waifu
      return 4;
    case 'Mythical': // Loli
      return 3;
    case 'Godly': // Spoiler
      return 2;
    case 'GOATED': // Holo Gaming
      return 1;
    default:
      return 0;
  }
}

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
  int _switchSpeed = 300;
  int _imageIndex = 0;
  static const int switchAmount = 28;

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
                if (_showGacha)
                  Align(alignment: Alignment.center, child: gachaShop(snapshot))
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
    final weights = snapshot.data!.map((e) => getTierNumber(e.tier)).toList();
    final weightsSum = weights.reduce((value, element) => value + element);

    final tierResults = <String, int>{};

    for (var i = 0; i < switchAmount + 2; i++) {
      var randomNum = rng.nextInt(weightsSum);

      for (var j = 0; j < snapshot.data!.length; j++) {
        if (randomNum < weights[j]) {
          pull.add(snapshot.data![j]);

          if (tierResults.containsKey(snapshot.data![j].tier)) {
            tierResults[snapshot.data![j].tier] =
                tierResults[snapshot.data![j].tier]! + 1;
          } else {
            tierResults[snapshot.data![j].tier] = 1;
          }

          break;
        } else {
          randomNum -= weights[j];
        }
      }
    }
    debugPrint(tierResults.toString());
    return pull;
  }

  void buttonLogic(BuildContext context, bool isChinese,
      AsyncSnapshot<List<SkinShopData>> snapshot) {
    Navigator.of(context).pop();
    _images = getGachaPull(snapshot);
    _showGacha = true;
    _imageIndex = 1;
  }

  late List<SkinShopData> _images;
  bool _timerActive = false;

  void _openPullWindow() {
    showDialog(
        context: context,
        builder: (context) {
          return PullWindow(
              data: _images[_imageIndex], colorScheme: colorScheme);
        });
  }

  void _switchImage() {
    setState(() {
      debugPrint('switching image');
      if (_timerActive && _imageIndex >= switchAmount) {
        _gachaRunning = false;
        _gachaDone = true;
        _timerActive = false;
        Timer(_getDuration(), _openPullWindow);
      } else if (_imageIndex < switchAmount) {
        _imageIndex = (_imageIndex + 1);
        _switchSpeed += 25;
        Timer(_getDuration(), _switchImage);
      }
    });
  }

  Duration _getDuration() {
    return Duration(milliseconds: _switchSpeed);
  }

  Widget? _leftImage;
  Widget? _rightImage;

  Widget gachaShop(AsyncSnapshot<List<SkinShopData>> snapshot) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: gachaWindow(),
              ),
            ),
            Text(_images[_imageIndex].name,
                style: const TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                debugPrint(_gachaDone.toString());
                if (_gachaDone) {
                  _gachaDone = false;
                  _gachaRunning = false;
                  _showGacha = false;
                } else {
                  if (!_gachaRunning) {
                    debugPrint("start gacha");
                    _switchSpeed = 200;
                    _timerActive = true;
                    _switchImage();
                    _gachaRunning = true;
                  }
                }
              },
              child: Text(_gachaDone ? 'End' : 'Start'),
            )
          ],
        ),
      ),
    );
  }

  AnimatedSwitcher gachaWindow() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: _switchSpeed),
      transitionBuilder: (Widget child, Animation<double> animation) {
        var inTween = Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0));
        var midTween = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
        var outTween = Tween<Offset>(begin: Offset(2, 0), end: Offset(1, 0));

        _leftImage = Image.asset(
          _images[_imageIndex - 1].imagePath,
          fit: BoxFit.contain,
        );
        _rightImage = Image.asset(
          _images[_imageIndex + 1].imagePath,
          fit: BoxFit.contain,
        );

        var rightImage = SlideTransition(
          position: outTween.animate(animation),
          child: _rightImage!,
        );
        var centerImage = SlideTransition(
          position: midTween.animate(animation),
          child: child,
        );
        var leftImage = SlideTransition(
          position: inTween.animate(animation),
          child: _leftImage!,
        );

        return Stack(
          children: [
            leftImage,
            centerImage,
            rightImage,
          ],
        );
      },
      child: Image.asset(
        _images[_imageIndex].imagePath,
        key: ValueKey(_imageIndex),
        fit: BoxFit.contain,
      ),
    );
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

class PullWindow extends StatefulWidget {
  const PullWindow({super.key, required this.data, required this.colorScheme});
  final SkinShopData data;
  final ColorScheme colorScheme;

  @override
  State<PullWindow> createState() => _PullWindowState();
}

class _PullWindowState extends State<PullWindow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('building pull window ${widget.data.bannerPath}');
    return Dialog(
      child: ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Congratulations! You got:',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                widget.data.bannerPath,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
            Text(
              widget.data.name,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              widget.data.tier,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the AnimationController
    super.dispose();
  }
}
