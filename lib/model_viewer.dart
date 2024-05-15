import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

int getPrice(String tier) {
  switch (tier) {
    case 'Free': // sata andagi
      return 0;
    case 'Trash': // funny Waifu
      return 380;
    case 'Common': // Bad Waifu
      return 100;
    case 'Uncommon': // normal Waifu
      return 150;
    case 'Rare': // Subpar Waifu
      return 200;
    case 'Epic': // Good Waifu
      return 300;
    case 'Legendary': // True Waifu
      return 400;
    case 'Mythical': // Loli
      return 500;
    case 'Godly': // Spoiler
      return 600;
    case 'GOATED': // Holo Gaming
      return 1000;
    default:
      return 0;
  }
}

class SkinShopData {
  final String name;
  final String imagePath;
  final String bannerPath;
  final String? soundPath;
  final String tier;

  const SkinShopData({
    required this.name,
    required this.imagePath,
    required this.bannerPath,
    this.soundPath,
    required this.tier,
  });
}

class SkinShopImage extends StatelessWidget {
  final SkinShopData data;
  final Color borderColor;

  const SkinShopImage(
      {required this.data, required this.borderColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          debugPrint(data.name);
          showDialog(
            context: context,
            builder: (context) {
              return purchasePopUp(context);
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Image.asset(
                  data.imagePath,
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
                                  data.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(child: Text(data.tier)),
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
    return AlertDialog(
      title: Text(data.name),
      content: Column(
        children: [
          Image.asset(data.bannerPath),
          Text('Price: ${getPrice(data.tier)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            debugPrint('Purchase');
          },
          child: const Text('Purchase'),
        ),
        TextButton(
          onPressed: () {
            debugPrint('Cancel');
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

Future<List<SkinShopData>> loadAssetImages() async {
  final jsonString = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(jsonString);

  manifestMap.keys
      .where((String key) => key.contains('the_goon_folder/'))
      .toList();

  const indexJsonPath = 'assets/the_goon_folder/goon_index.json';
  final indexJsonString = await rootBundle.loadString(indexJsonPath);
  final Map<String, dynamic> indexJson = json.decode(indexJsonString);
  final images = indexJson.entries.map((entry) {
    String? soundPath;
    String path = "assets/the_goon_folder/icons/${entry.value['filepath']}";
    String bannerPath =
        "assets/the_goon_folder/banners/${entry.value['filepath']}";
    String name = entry.key;
    String tier = entry.value["tier"];
    if (path.contains('sata_andagi')) {
      soundPath = 'assets/sounds/sata_andagi.mp3';
    }
    debugPrint('path: $path, name: $name, tier: $tier');

    return SkinShopData(
      name: name,
      imagePath: path,
      bannerPath: bannerPath,
      soundPath: soundPath,
      tier: tier,
    );
  }).toList();

  return images;
}

class Dookie3DViewer extends StatefulWidget {
  const Dookie3DViewer({super.key});

  @override
  State<Dookie3DViewer> createState() => _Dookie3DViewerState();
}

class _Dookie3DViewerState extends State<Dookie3DViewer>
    with SingleTickerProviderStateMixin {
  O3DController controller = O3DController();
  late ColorScheme colorScheme;
  double extend = 0;
  late Future<List<SkinShopData>> _skinShopDataFuture;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _skinShopDataFuture = loadAssetImages();
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
                child: Row(
              children: [
                IconButton(
                    onPressed: () => controller.cameraOrbit(-25, 90, 50),
                    icon: const Icon(Icons.change_circle)),
                IconButton(
                    onPressed: () => controller.cameraTarget(0, 0, 0),
                    icon: const Icon(Icons.change_circle_outlined)),
              ],
            )),
            Expanded(
              flex: 7,
              child: O3D.asset(
                src: 'assets/models/t1bulli.glb',
                controller: controller,
              ),
            ),
            Expanded(
                child: SizedBox.expand(
              child: ElevatedButton(
                onPressed: () {
                  if (_animController.isDismissed) {
                    _animController.forward();
                  } else if (_animController.isCompleted) {
                    _animController.reverse();
                  }
                },
                child: const Text('Shop'),
              ),
            )),
          ],
        ),
        IgnorePointer(
          child: Container(
            color: Colors.black.withOpacity(extend),
          ),
        ),
        // skinShopNotifier(),
        shopView(),
      ],
    );
  }

  final Tween<Offset> _tween =
      Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0));

  Widget shopView() {
    return LayoutBuilder(builder: ((context, constraints) {
      return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: SlideTransition(
            position: _tween.animate(_animController),
            child:
                DraggableScrollableSheet(builder: (context, scrollController) {
              return shopData(scrollController: scrollController);
            }),
          ));
    }));
  }

  FutureBuilder<List<SkinShopData>> shopData(
      {required ScrollController? scrollController}) {
    return FutureBuilder<List<SkinShopData>>(
      future: _skinShopDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount =
                  constraints.maxWidth ~/ 125; // Adjust the divisor as needed
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Stack(
                        children: [
                          const Center(
                            child: Text(
                              'The Goon Store',
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: -4,
                            child: IconButton(
                              onPressed: () {
                                if (_animController.isDismissed) {
                                  _animController.forward();
                                } else if (_animController.isCompleted) {
                                  _animController.reverse();
                                }
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox.expand(
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return SkinShopImage(
                              data: snapshot.data![index],
                              borderColor: colorScheme.onSecondary,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
