import 'package:flutter/material.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:o3d/o3d.dart';

// class Dookie3DViewer extends StatelessWidget {
//   const Dookie3DViewer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ModelViewer(
//       src: 'assets/models/dingus_cat.glb',
//       alt: 'A 3D model of an astronaut',
//       ar: false,
//       autoRotate: true,
//       cameraControls: true,
//     );
//   }
// }

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
          child: ListView(
            controller: scrollController,
            children: [
              IconButton(
                onPressed: () => controller.cameraOrbit(-25, 90, 50),
                icon: const Icon(Icons.change_circle),
              ),
              IconButton(
                onPressed: () => controller.cameraTarget(0, 0, 0),
                icon: const Icon(Icons.change_circle_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
