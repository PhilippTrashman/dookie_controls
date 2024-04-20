import 'package:flutter/material.dart';
import 'package:dookie_controls/color_schemes/color_schemes.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class CarBrand {
  final String name;
  final String logo;

  CarBrand(this.name, this.logo);

}

class User {
  final String name;
  final String lastName;
  final CarBrand carBrand;

  User({
    required this.name,
    required this.lastName,
    required this.carBrand}
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static CarBrand carBrand = CarBrand("Toyota", "toyota_logo.png");
  static List users = [
    User(name: "John", lastName: "Doe", carBrand: carBrand)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ignitionLock()
          )
          Expanded(
            flex: 1,
            child: GridView.builder(
              gridDelegate: gridDelegate, 
              itemBuilder: itemBuilder),
            
          )
        ],
      )),
    );
  }

  Widget ignitionLock() {
    return IconButton(
      onPressed: () {
        print("Button pressed");
      },
      icon: const Icon(Icons.key),
    );
  }

  Widget ignitionKey() {

  }
}
