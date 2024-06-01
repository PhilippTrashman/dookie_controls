import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:dookie_controls/bluetooth_serial/select_bonded_device_page.dart';
import 'package:dookie_controls/dookie_notifier.dart';
import 'package:dookie_controls/imports.dart';

import 'package:dookie_controls/ads.dart';

class Connectionpage extends StatefulWidget {
  const Connectionpage({super.key});

  @override
  State<Connectionpage> createState() => _ConnectionpageState();
}

class _ConnectionpageState extends State<Connectionpage> {
  late DookieNotifier dn;
  late ColorScheme colorScheme;

  double pi = 3.14159265359;
  late bool turnDisabled;

  @override
  Widget build(BuildContext context) {
    dn = Provider.of<DookieNotifier>(context);
    colorScheme = Theme.of(context).colorScheme;
    turnDisabled = dn.selectedUser?.carBrand.id == 2;
    return mainScreen();
  }

  Widget textDivider({required double height, required String header}) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              height: height,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            header,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Divider(
              height: height,
            ),
          ),
        ],
      ),
    );
  }

  Widget engineErrors() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: Image.asset('assets/images/engine_errors/warning.png'),
          ),
          Expanded(
            child: Image.asset('assets/images/engine_errors/battery.png'),
          ),
          Expanded(
            child: Image.asset('assets/images/engine_errors/motor.png'),
          ),
          Expanded(
            child: Image.asset('assets/images/engine_errors/oel.png'),
          ),
          Expanded(
            child: Image.asset('assets/images/engine_errors/temp.png'),
          ),
        ],
      ),
    );
  }

  Widget mainScreen() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool vertical = height * 1.5 > width;
        return vertical ? verticalView(height) : horizontalView(height);
      },
    );
  }

  Widget verticalBanner({required bool shown}) {
    if (!shown) {
      return const SizedBox();
    }
    return const SingleChildScrollView(
      child: Column(
        children: [
          Ads(verticalAd: true),
          Ads(verticalAd: true),
          Ads(verticalAd: true),
        ],
      ),
    );
  }

  Widget horizontalView(double height) {
    bool shown = dn.selectedUser?.carBrand.id == 1;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: verticalBanner(shown: shown)),
          const VerticalDivider(),
          Expanded(
              flex: 8,
              child: Container(
                color: colorScheme.secondaryContainer,
                child: verticalView(height),
              )),
          const VerticalDivider(),
          Expanded(child: verticalBanner(shown: shown)),
        ],
      ),
    );
  }

  double rotation = 0;

  String getSteeringWheelPicture() {
    switch (dn.selectedUser?.carBrand.id) {
      case 1:
        return 'assets/images/steering_wheels/volkswagen.png';
      case 2:
        return 'assets/images/steering_wheels/bmw.png';
      case 4:
        return 'assets/images/steering_wheels/lada.png';
      case 5:
        return 'assets/images/steering_wheels/go_shi_he.png';
      default:
        return 'assets/images/steering_wheels/go_shi_he.png';
    }
  }

  Widget steeringWheel(double height) {
    return SizedBox(
      height: height * 0.3,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                if (!turnDisabled)
                  Expanded(
                    child: _indicators(),
                  )
                else
                  Expanded(child: engineErrors()),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 6,
                  child: _steeringWheel(),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(
                child: controllerButton(
                  startMessage: 'speed:100',
                  stopMessage: 'stop',
                  icon: Icons.double_arrow,
                  degrees: 270,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: controllerButton(
                    startMessage: 'speed:50',
                    stopMessage: 'stop',
                    degrees: 270,
                    icon: Icons.arrow_forward_ios),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: controllerButton(
                    startMessage: 'speed:-50',
                    stopMessage: 'stop',
                    degrees: 90,
                    icon: Icons.arrow_forward_ios),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: controllerButton(
                      startMessage: 'speed:-100',
                      stopMessage: 'stop',
                      degrees: 90,
                      icon: Icons.double_arrow)),
            ],
          )
        ],
      ),
    );
  }

  Row _indicators() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              sendMessage('indicator-left');
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              sendMessage('indicator-right');
            },
            child: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }

  int? _lastSentStep;
  String _lastMessage = 'steering:0';

  Stack _steeringWheel() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newRotation = rotation + details.delta.dx / 100;
                    if (newRotation < -0.75) {
                      newRotation = -0.75;
                    } else if (newRotation > 0.75) {
                      newRotation = 0.75;
                    }
                    rotation = newRotation;

                    // Map the rotation to the range -100 to 100

                    int mappedRotation = (rotation * 133.33).round();

                    // Calculate the current step
                    int currentStep = (mappedRotation / 10).round() * 10;

                    // If the current step is at least 10 steps away from the last sent step, send a new message
                    if ((_lastSentStep == null) ||
                        (currentStep - _lastSentStep!).abs() >= 10) {
                      _lastMessage = 'steering:$currentStep';
                      debugPrint(_lastMessage);
                      _lastSentStep = currentStep;
                      sendMessage(_lastMessage);
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newRotation = rotation - details.delta.dx / 100;
                    if (newRotation < -0.75) {
                      newRotation = -0.75;
                    } else if (newRotation > 0.75) {
                      newRotation = 0.75;
                    }
                    rotation = newRotation;
                  });
                },
              ),
            ),
          ],
        ),
        IgnorePointer(
          child: Center(
            child: Transform.rotate(
              angle: rotation,
              child: Image.asset(
                getSteeringWheelPicture(),
                fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ],
    );
  }

  Column verticalView(double height) {
    return Column(
      children: [
        if (dn.selectedUser?.carBrand.id == 1)
          const Expanded(
            flex: 1,
            child: Ads(
              verticalAd: false,
            ),
          ),
        Divider(
          height: height * 0.01,
        ),
        Expanded(
          flex: 8,
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    textDivider(
                      height: height * 0.05,
                      header: workingConnection(),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: height * 0.11,
                      child: autoPilotButton(height),
                    ),
                    textDivider(
                      height: height * 0.05,
                      header: 'Controller',
                    ),
                    steeringWheel(height),
                    textDivider(
                        height: height * 0.05, header: 'Connection Status'),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: height * 0.1,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          onPressed: () async {
                            // connectToDevice();
                            if (dn.isConnected) {
                              dn.disconnectFromDevice();
                            } else {
                              await handleConnectRequest();
                              // connectToDevice();
                            }
                          },
                          child: Text(
                            dn.isConnected ? 'Disconnect' : 'Connect',
                          )),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: height * 0.1,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        onPressed: () {
                          sendMessage('steering:0');
                          sendMessage('auto-pilot-stop');
                          setState(() {
                            _lastMessage = 'steering:0';
                            _lastSentStep = null;
                            rotation = 0;
                            isAutoPilot = false;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    )
                  ],
                )),
          ),
        ),
        Divider(
          height: height * 0.01,
        ),
        if (dn.selectedUser?.carBrand.id == 1)
          const Expanded(
            flex: 1,
            child: Ads(
              verticalAd: false,
            ),
          ),
      ],
    );
  }

  bool isAutoPilot = false;

  Widget autoPilotButton(double height) {
    return SizedBox(
        height: height * 0.11,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Auto Pilot'),
                Switch(
                  value: isAutoPilot,
                  onChanged: (value) {
                    if (dn.isConnected) {
                      sendMessage(
                          value ? 'auto-pilot-start' : 'auto-pilot-stop');
                      setState(() {
                        isAutoPilot = value;
                        debugPrint('Auto Pilot: $isAutoPilot');
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget controllerButton({
    required String startMessage,
    required String stopMessage,
    double degrees = 0,
    IconData icon = Icons.arrow_upward,
    bool doubleIcon = false,
  }) {
    return SizedBox(
      child: Listener(
        onPointerDown: (details) {
          sendMessage(startMessage);
        },
        onPointerUp: (details) {
          sendMessage(stopMessage);
        },
        child: ElevatedButton(
          onPressed: () {},
          child: Transform.rotate(
            angle: degrees * pi / 180,
            child: !doubleIcon
                ? Icon(icon)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(icon),
                      Icon(icon),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buttonChild({
    required double height,
    Widget? leftChild,
    Widget? rightChild,
  }) {
    bool showSeperator = rightChild != null && leftChild != null;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Row(
        children: [
          if (leftChild != null)
            Expanded(
              child: leftChild,
            ),
          if (showSeperator)
            const SizedBox(
              width: 10,
            ),
          if (rightChild != null)
            Expanded(
              child: rightChild,
            ),
        ],
      ),
    );
  }

  String workingConnection() {
    return dn.isConnecting
        ? 'Connecting...'
        : dn.isConnected
            ? 'Connected'
            : 'Not Connected';
  }

  Future handleConnectRequest() async {
    await Permission.bluetoothScan.status.then((value) async {
      debugPrint("-------!${value.isGranted}!-------");
      if (value.isGranted) {
        debugPrint('Bluetooth permission granted');
        connectToDevice();
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Bluetooth Permission'),
                content: const Text(
                    'This app requires bluetooth permission to connect to the device, please allow location and nearby devices permission to continue.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await openAppSettings().then((value) async {
                        Navigator.of(context).pop();
                        await Permission.bluetoothScan.status.then((value) {
                          debugPrint("-------!${value.isGranted}!-------");
                          if (value.isGranted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Bluetooth permission granted, please try again.')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Bluetooth permission is required to connect to the device.')));
                          }
                        });
                      });
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              );
            });
      }
    });
  }

  void connectToDevice() async {
    final BluetoothDevice? device = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const SelectBondedDevicePage(checkAvailability: false);
        },
      ),
    );

    if (device == null) {
      debugPrint('No device selected');
      return;
    } else {
      dn.connectToDevice(device);
    }
  }

  void sendMessage(String message) async {
    if (!dn.isConnected) {
      return;
    }
    final text = message.trim();

    if (text.isNotEmpty) {
      try {
        dn.connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await dn.connection!.output.allSent;

        debugPrint('Sent: $text');
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  Widget connectionButton() {
    return ElevatedButton(
      onPressed: () {
        debugPrint('Connecting to Bluetooth');
      },
      child: Icon(
        Icons.bluetooth_searching,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
