import 'dart:io';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:dookie_controls/dookie_notifier.dart';
import 'package:flutter/material.dart';
import 'package:dookie_controls/skin_shop/shop_data.dart';
import 'package:o3d/o3d.dart';

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
  late DookieNotifier dn;
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
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    dn = Provider.of<DookieNotifier>(context);
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                              containerColor: colorScheme.secondaryContainer,
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
