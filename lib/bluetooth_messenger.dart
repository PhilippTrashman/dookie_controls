import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Widget mainScreen() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool vertical = height > 500;
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
              )),
          const VerticalDivider(),
          Expanded(child: verticalBanner(shown: shown)),
        ],
      ),
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
                    SizedBox(
                      height: height * 0.1,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          onPressed: () {
                            if (dn.isConnected) {
                              debugPrint('Joystick View');
                            }
                          },
                          child: const Text(
                            'Joystick View',
                          )),
                    ),
                    textDivider(
                      height: height * 0.05,
                      header: 'Controller',
                    ),
                    controllerView(
                      height: height * 0.3,
                    ),
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
                          onPressed: () {
                            // connectToDevice();
                            if (dn.isConnected) {
                              dn.disconnectFromDevice();
                            } else {
                              connectToDevice();
                            }
                          },
                          child: Text(
                            dn.isConnected ? 'Disconnect' : 'Connect',
                          )),
                    ),
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

  Widget controllerButton({
    required String startMessage,
    required String stopMessage,
    double degrees = 0,
  }) {
    return SizedBox.expand(
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
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
    );
  }

  Widget controllerView({required double height}) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          if (turnDisabled) const Expanded(flex: 2, child: SizedBox()),
          if (!turnDisabled)
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () {
                          sendMessage('indicator-left');
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
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
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () {
                          sendMessage('indicator-right');
                        },
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                    child: controllerButton(
                        startMessage: 'up-left',
                        stopMessage: 'stop',
                        degrees: 315)),
                const SizedBox(
                  width: 10,
                ),
                // Expanded(
                Expanded(
                  child: controllerButton(
                      startMessage: 'up-null', stopMessage: 'stop'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: controllerButton(
                    startMessage: 'up-right',
                    stopMessage: 'stop',
                    degrees: 45,
                  ),
                )
              ],
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: controllerButton(
                    startMessage: 'down-left',
                    stopMessage: 'stop',
                    degrees: 225,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: controllerButton(
                    startMessage: 'down-null',
                    stopMessage: 'stop',
                    degrees: 180,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: controllerButton(
                    startMessage: 'down-right',
                    stopMessage: 'stop',
                    degrees: 135,
                  ),
                ),
              ],
            ),
          )
        ],
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

  Widget workingConnection() {
    return Column(
      children: [
        Text(
          dn.isConnecting
              ? 'Connecting...'
              : dn.isConnected
                  ? 'Connected'
                  : 'Not Connected',
        ),
      ],
    );
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
