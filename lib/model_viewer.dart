import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SkinShopImage extends StatelessWidget {
  final String imagePath;
  final String? soundPath;

  const SkinShopImage({required this.imagePath, this.soundPath, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(child: Text('Price: 1099 DC')),
          ],
        ),
      ),
    );
  }
}

Future<List<SkinShopImage>> loadAssetImages() async {
  final jsonString = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(jsonString);

  final imagePaths = manifestMap.keys
      .where((String key) => key.contains('the_goon_folder/'))
      .toList();

  final images = imagePaths.map((path) {
    String? soundPath;
    if (path.contains('sata_andagi')) {
      soundPath = 'assets/sounds/sata_andagi.mp3';
    }

    return SkinShopImage(imagePath: path, soundPath: soundPath);
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
          child: FutureBuilder<List<SkinShopImage>>(
            future: loadAssetImages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return snapshot.data![index];
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
