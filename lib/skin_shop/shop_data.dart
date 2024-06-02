import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:dookie_controls/dookie_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';

class SkinShopData {
  final int id;
  final String name;
  final String imagePath;
  final String bannerPath;
  final String portraitPath;
  final String? soundPath;
  final String tier;

  const SkinShopData({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.bannerPath,
    required this.portraitPath,
    this.soundPath,
    required this.tier,
  });

  int get tierGroup {
    switch (tier) {
      case 'Free':
        return 10;
      case 'Trash':
        return 9;
      case 'Common':
        return 8;
      case 'Uncommon':
        return 7;
      case 'Rare':
        return 6;
      case 'Epic':
        return 5;
      case 'Legendary':
        return 4;
      case 'Mythical':
        return 3;
      case 'Godly':
        return 2;
      case 'GOATED':
        return 1;
      default:
        return 0;
    }
  }

  int get price {
    switch (tier) {
      case 'Free': // sata andagi
        return 0;
      case 'Trash': // funny Waifu
        return 380;
      case 'Common': // Bad Waifu
        return 560;
      case 'Uncommon': // normal Waifu
        return 780;
      case 'Rare': // Subpar Waifu
        return 1280;
      case 'Epic': // Good Waifu
        return 1860;
      case 'Legendary': // True Waifu
        return 2440;
      case 'Mythical': // Loli
        return 2870;
      case 'Godly': // Spoiler
        return 3640;
      case 'GOATED': // Holo Gaming
        return 4850;
      default:
        return 0;
    }
  }

  String get message {
    switch (tier) {
      case 'Free':
        return 'This skin is brought to by the hit Game RAID: Shadow Legends';
      default:
        return 'To Unlock the $tier Skin of $name you only need to spend a measly $price Dookie Points and then Enjoy your Favourite Waifu';
    }
  }
}

bool purchasableSkin(String name) {
  return ["Go Jo", "Asuka", "Mikasa", "Fenrys"].contains(name);
}

class SkinShopImage extends StatefulWidget {
  final SkinShopData data;
  final Color borderColor;
  final Color containerColor;

  const SkinShopImage(
      {required this.data,
      required this.borderColor,
      required this.containerColor,
      super.key});

  @override
  State<SkinShopImage> createState() => _SkinShopImageState();
}

class _SkinShopImageState extends State<SkinShopImage> {
  late DookieNotifier dn;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    dn = Provider.of<DookieNotifier>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (dn.selectedUser!.unlockedSkins.isSkinUnlocked(widget.data.id)) {
            showDialog(
                context: context, builder: (context) => applyPopUp(context));
          } else {
            showDialog(
              barrierDismissible: widget.data.name != 'Sata Andagi',
              context: context,
              builder: (context) {
                return purchasePopUp(context);
              },
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.borderColor,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Image.asset(
                  widget.data.imagePath,
                  fit: BoxFit.fill,
                ),
                Column(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: SizedBox.expand(
                          child: Column(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.data.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(child: Text(widget.data.tier)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget purchasePopUp(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isPortrait = constraints.maxHeight > constraints.maxWidth;
      if (widget.data.tier == 'Free') {
        return SataAndagiPopUp(data: widget.data);
      }
      return Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              isPortrait ? widget.data.portraitPath : widget.data.bannerPath,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(child: buyMessage(context))
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget applyPopUp(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isPortrait = constraints.maxHeight > constraints.maxWidth;
      return Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              isPortrait ? widget.data.portraitPath : widget.data.bannerPath,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  flex: 6,
                  child: SizedBox(),
                ),
                Expanded(
                    child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          children: [
                            Text(
                              widget.data.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    dn.applySkin(widget.data.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Apply'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        )))
              ],
            ),
          ],
        ),
      );
    });
  }

  Container buyMessage(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Column(
        children: [
          Text(
            widget.data.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.data.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (purchasableSkin(widget.data.name)) {
                        final result = dn.buySkin(widget.data);
                        if (!result) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Not enough Dookie Points'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Skin Purchased ${widget.data.name}'),
                            ),
                          );
                        }
                        Navigator.of(context).pop();
                      } else {
                        final Uri url = Uri.parse("https://www.ea.com/de-de");
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      }
                    },
                    child: const Text('Purchase'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map<int, SkinShopData>> loadAssetImages() async {
  final jsonString = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(jsonString);

  manifestMap.keys
      .where((String key) => key.contains('the_goon_folder/'))
      .toList();

  const indexJsonPath = 'assets/the_goon_folder/goon_index.json';
  final indexJsonString = await rootBundle.loadString(indexJsonPath);
  final Map<String, dynamic> indexJson = json.decode(indexJsonString);
  final images = Map<int, SkinShopData>.fromIterable(
    indexJson.entries,
    key: (entry) => entry.value['id'],
    value: (entry) {
      String? soundPath;
      String path = "assets/the_goon_folder/icons/${entry.value['filepath']}";
      String bannerPath =
          "assets/the_goon_folder/banners/${entry.value['filepath']}";
      String portraitPath =
          "assets/the_goon_folder/portraits/${entry.value['filepath']}";
      String name = entry.key;
      String tier = entry.value["tier"];
      if (path.contains('sata_andagi')) {
        soundPath = 'assets/sounds/sata_andagi.mp3';
      }
      final int id = entry.value['id'];

      return SkinShopData(
        id: id,
        name: name,
        imagePath: path,
        bannerPath: bannerPath,
        portraitPath: portraitPath,
        soundPath: soundPath,
        tier: tier,
      );
    },
  );

  return images;
}

class SataAndagiPopUp extends StatefulWidget {
  final SkinShopData data;

  const SataAndagiPopUp({required this.data, super.key});

  @override
  State<SataAndagiPopUp> createState() => _SataAndagiPopUpState();
}

class _SataAndagiPopUpState extends State<SataAndagiPopUp>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    Timer(const Duration(milliseconds: 500), () {
      _playMusic();
    });
    Timer(const Duration(milliseconds: 3000), () {
      _stopMusic();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    // _stopMusic();
    super.dispose();
  }

  void _playMusic() async {
    await _audioPlayer.setSource(AssetSource('sounds/sata_andagi.mp3'));
    await _audioPlayer.resume();
  }

  void _stopMusic() async {
    await _audioPlayer.stop().then((value) {
      _audioPlayer.dispose();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Curves.easeOut,
        ),
      ),
      child: Dialog(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.data.imagePath,
                fit: BoxFit.fill,
              ),
            )),
      ),
    );
  }
}
