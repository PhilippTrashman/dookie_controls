import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dookie_controls/dookie_notifier.dart';
import 'package:dookie_controls/bluetooth_serial/select_bonded_device_page.dart';
import 'package:dookie_controls/imports.dart';

class Connectionpage extends StatefulWidget {
  const Connectionpage({super.key});

  @override
  State<Connectionpage> createState() => _ConnectionpageState();
}

class _ConnectionpageState extends State<Connectionpage> {
  late DookieNotifier dookieNotifier;
  bool isConnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;
  String serverName = '';
  BluetoothConnection? connection;
  @override
  Widget build(BuildContext context) {
    dookieNotifier = Provider.of<DookieNotifier>(context);
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


