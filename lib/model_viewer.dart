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

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    return Column(
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
          flex: 5,
          child: O3D.asset(
            src: 'assets/models/dingus_cat.glb',
            controller: controller,
          ),
        ),
        Expanded(
          child: DraggableScrollableSheet(
            initialChildSize: 0.5, // Adjust this as needed
            minChildSize: 0.5, // Adjust this as needed
            maxChildSize: 1, // Adjust this as needed
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
          ),
        ),
      ],
    );
  }
}
