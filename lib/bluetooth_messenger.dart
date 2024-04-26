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
  late DookieNotifier dookieNotifier;
  late ColorScheme colorScheme;
  bool isConnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;
  String serverName = '';
  BluetoothConnection? connection;

  @override
  Widget build(BuildContext context) {
    dookieNotifier = Provider.of<DookieNotifier>(context);
    colorScheme = Theme.of(context).colorScheme;
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
    bool shown = dookieNotifier.selectedUser?.carBrand.id == 1;
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
        if (dookieNotifier.selectedUser?.carBrand.id == 1)
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
                    buttonChild(
                      height: height * 0.1,
                      leftChild: Container(
                          height: height * 0.1,
                          color: Colors.amber,
                          child: const Text(
                            'Joy Stick View',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
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
                    buttonChild(
                      height: height * 0.2,
                      leftChild: Container(
                        color: Colors.red,
                      ),
                      // rightChild: Container(
                      //   color: Colors.blue,
                      // ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buttonChild(
                      height: height * 0.1,
                      leftChild: Container(
                        color: Colors.amber,
                      ),
                      rightChild: Container(
                        color: Colors.blue,
                      ),
                    )
                  ],
                )),
          ),
        ),
        Divider(
          height: height * 0.01,
        ),
        if (dookieNotifier.selectedUser?.carBrand.id == 1)
          const Expanded(
            flex: 1,
            child: Ads(
              verticalAd: false,
            ),
          ),
      ],
    );
  }

  Widget controllerView({required double height}) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
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
                  child: Container(
                    color: Colors.white,
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
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
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
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
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
          isConnecting
              ? 'Connecting...'
              : isConnected
                  ? 'Connected'
                  : 'Not Connected',
        ),
        connectionButton(),
        ElevatedButton(
          onPressed: connectToDevice,
          child: const Text('Connect to Device'),
        ),
        ElevatedButton(
          onPressed: () {
            sendMessage('Hello');
          },
          child: const Text('Send Message'),
        )
      ],
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {});
    } else {}
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
      debugPrint('Device selected: ${device.name}');
      dookieNotifier.connectedDevice = device;
      serverName = device.name ?? 'Unknown';
      setState(() {});
    }

    BluetoothConnection.toAddress(device.address).then((connection) {
      debugPrint('Connected to the device');
      connection = connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          debugPrint('Disconnecting locally!');
        } else {
          debugPrint('Disconnected remotely!');
        }
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      debugPrint('Cannot connect, exception occured');
      debugPrint(error);
    });
  }

  void sendMessage(String message) async {
    final text = message.trim();

    if (text.isNotEmpty) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await connection!.output.allSent;

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

// Path: lib/bluetooth_serial/SelectBondedDevicePage.dart
