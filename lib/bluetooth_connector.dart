// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class BluetoothConnector {
//   static final FlutterBluetoothSerial bluetooth =
//       FlutterBluetoothSerial.instance;

//   static Future<void> connect(BluetoothDevice device) async {
//     await bluetooth.connect(device);
//   }

//   static Future<void> disconnect() async {
//     await bluetooth.disconnect();
//   }

//   static Future<void> write(String message) async {
//     await bluetooth.write(message);
//   }

//   static Future<void> listen(void Function(String) onData) async {
//     bluetooth.onRead().listen(onData);
//   }
// }
