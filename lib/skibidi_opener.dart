import 'dart:async';
import 'dart:io';

import 'package:dookie_controls/models/gacha_save.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late bool isCheater;
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

  List<GachaWidget> gachaTexts(List<SkinShopData> list) {
    final Map<int, SkinShopData> gachaItems =
        list.asMap().map((k, v) => MapEntry(k + 1, v));
    final List<GachaWidget> gachaContainer = [];

    final userGachas = dn.selectedUser!.gachaSave.gachas;

    for (final item in userGachas.values) {
      if (gachaItems.containsKey(item.id)) {
        gachaContainer.add(GachaWidget(
            data: gachaItems[item.id]!,
            gachaSave: item,
            colorScheme: colorScheme));
      }
    }
    return gachaContainer;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    dn = Provider.of<DookieNotifier>(context);
    colorScheme = Theme.of(context).colorScheme;
    isCheater = dn.selectedUser?.isCheater ?? false;

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

  Stack mainPage(
      BuildContext context, AsyncSnapshot<List<SkinShopData>> snapshot) {
    return Stack(
      children: [
        Column(
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
                    child: Text(
                        'Dookies ${dn.selectedUser!.dookieSave.dookieAmount.toInt()}'),
                  ),
                ),
              ),
            ),
            const Expanded(
                child: Center(
                    child: Text('Rewards', style: TextStyle(fontSize: 24)))),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: userGachas(snapshot),
              ),
            ),
            Expanded(
              flex: 2,
              child: bottomButtons(context, snapshot),
            ),
          ],
        ),
        if (_showGacha)
          Container(
              color: Colors.black.withOpacity(0.5),
              child: Align(
                  alignment: Alignment.center, child: gachaShop(snapshot))),
      ],
    );
  }

  Column bottomButtons(
      BuildContext context, AsyncSnapshot<List<SkinShopData>> snapshot) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: SizedBox.expand(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                ),
                onPressed: () {
                  if (_showGacha) {
                    return;
                  }
                  showDialog(
                      context: context,
                      builder: (context) {
                        return buyMessage(context, snapshot);
                      });
                },
                child: Text(
                  'Open Case',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: colorScheme.onBackground, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
        if (isCheater)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondaryContainer,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return addCheaterMode(snapshot.data!);
                        });
                  },
                  child: Text(
                    'Cheater Mode',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: colorScheme.onBackground, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Container userGachas(AsyncSnapshot<List<SkinShopData>> snapshot) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
        ),
        child: Center(child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth ~/ 125;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: gachaTexts(snapshot.data!).length,
              itemBuilder: (context, index) {
                return gachaTexts(snapshot.data!)[index];
              },
            );
          },
        )));
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

  final int _payAmount = 249;

  void buttonLogic(BuildContext context, bool isChinese,
      AsyncSnapshot<List<SkinShopData>> snapshot) {
    Navigator.of(context).pop();
    if (dn.selectedUser != null) {
      if (dn.selectedUser!.dookieSave.dookieAmount >= _payAmount || isCheater) {
        if (!isCheater) {
          dn.selectedUser!.dookieSave.dookieAmount -= _payAmount;
        }
        _images = getGachaPull(snapshot);
        _showGacha = true;
        _imageIndex = 1;
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(isChinese ? '你壞了，婊子' : 'You Broke, Bitch'),
            ),
          );
      }
    }
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
    if (dn.selectedUser != null) {
      dn.selectedUser!.gachaSave.addGacha(_images[_imageIndex].id);
      debugPrint(dn.selectedUser!.gachaSave.gachas.toString());
    }
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
    int payAmount = isCheater ? 0 : _payAmount;
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
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Pay $payAmount Dookies to open the case?'),
                    Text('支付 $payAmount Dookies 即可開啟箱子?'),
                    if (isCheater)
                      const Text('Cheater',
                          style: TextStyle(
                            color: Colors.red,
                          )),
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
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addCheaterMode(List<SkinShopData> list) {
    List<ListTile> tiles() {
      return list
          .map((e) => ListTile(
                title: Text(e.name),
                subtitle: Text(e.tier),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (dn.selectedUser != null) {
                          dn.selectedUser!.gachaSave.addGacha(e.id);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (dn.selectedUser != null) {
                          dn.selectedUser!.gachaSave.removeGacha(e.id);
                        }
                      },
                    ),
                  ],
                ),
              ))
          .toList();
    }

    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        children: [
          ...tiles(),
        ],
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
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      ),
      child: Dialog(
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  widget.data.bannerPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
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

class GachaWidget extends StatelessWidget {
  const GachaWidget(
      {super.key,
      required this.data,
      required this.gachaSave,
      required this.colorScheme});
  final SkinShopData data;
  final GachaSaveObject gachaSave;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.onSecondary,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(data.imagePath, fit: BoxFit.fill),
              ),
            ),
            Column(
              children: [
                const Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Expanded(
                    child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: SizedBox.expand(
                    child: Text(
                      '${gachaSave.amount}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
