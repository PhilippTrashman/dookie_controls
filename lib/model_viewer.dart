import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SkinShopData {
  final String name;
  final String imagePath;
  final String? soundPath;
  final int price;

  const SkinShopData({
    required this.name,
    required this.imagePath,
    this.soundPath,
    required this.price,
  });
}

class SkinShopImage extends StatelessWidget {
  SkinShopData data;
  Color borderColor;

  SkinShopImage({required this.data, required this.borderColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                            Expanded(child: Text('${data.price} DC')),
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
    );
  }
}

Future<List<SkinShopData>> loadAssetImages() async {
  final jsonString = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(jsonString);

  final imagePaths = manifestMap.keys
      .where((String key) => key.contains('the_goon_folder/'))
      .toList();

  const indexJsonPath = 'assets/the_goon_folder/goon_index.json';
  final indexJsonString = await rootBundle.loadString(indexJsonPath);
  final Map<String, dynamic> indexJson = json.decode(indexJsonString);
  final images = indexJson.entries.map((entry) {
    String? soundPath;
    String path = "assets/the_goon_folder/${entry.value['filepath']}";
    String name = entry.key;
    int price = entry.value["price"];
    if (path.contains('sata_andagi')) {
      soundPath = 'assets/sounds/sata_andagi.mp3';
    }
    debugPrint('path: $path, name: $name, price: $price');

    return SkinShopData(
      name: name,
      imagePath: path,
      soundPath: soundPath,
      price: price,
    );
  }).toList();

  return images;
}

class Dookie3DViewer extends StatefulWidget {
  const Dookie3DViewer({super.key});

  @override
  State<Dookie3DViewer> createState() => _Dookie3DViewerState();
}

class _Dookie3DViewerState extends State<Dookie3DViewer> {
  O3DController controller = O3DController();
  late ColorScheme colorScheme;
  double extend = 0;
  late Future<List<SkinShopData>> _skinShopDataFuture;

  @override
  void initState() {
    super.initState();
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
                src: 'assets/models/dingus_cat.glb',
                controller: controller,
              ),
            ),
            Expanded(
              child: Container(
                color: colorScheme.secondaryContainer,
              ),
            ),
          ],
        ),
        IgnorePointer(
          child: Container(
            color: Colors.black.withOpacity(extend),
          ),
        ),
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent > 0.11) {
              if (notification.extent < 0.7) {
                setState(() {
                  if (notification.extent > 0.2) {
                    extend = notification.extent - 0.2;
                  } else {
                    extend = 0;
                  }
                });
              }
            } else {
              setState(() {
                extend = 0;
              });
            }
            return false;
          },
          child: skinShop(),
        ),
      ],
    );
  }

  DraggableScrollableSheet skinShop() {
    return DraggableScrollableSheet(
      initialChildSize: 0.11, // Adjust this as needed
      minChildSize: 0.11, // Adjust this as needed
      maxChildSize: 0.8, // Adjust this as needed
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: colorScheme.secondaryContainer,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'The Goon Shop',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<SkinShopData>>(
                  future: _skinShopDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate the number of columns
                          final crossAxisCount = constraints.maxWidth ~/
                              125; // Adjust the divisor as needed

                          return GridView.builder(
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
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
