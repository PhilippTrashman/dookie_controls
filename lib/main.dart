import 'package:flutter/material.dart';
import 'package:dookie_controls/color_schemes/color_schemes.g.dart';
import 'package:dookie_controls/imports.dart';
import 'package:dookie_controls/dookie_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DookieNotifier(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
        home: const MyHomePage(title: 'Dookie Controls'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ColorScheme colorScheme;
  User? selectedUser;
  List users = DookieNotifier.users;
  late DookieNotifier dookieNotifier;
  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    dookieNotifier = Provider.of<DookieNotifier>(context);
    return shownScreen();
  }

  Widget shownScreen() {
    if (dookieNotifier.selectedUser != null) {
      return const MainPage();
    } else {
      return logInScreen();
    }
  }

  Widget logInScreen() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Container(child: ignitionLock())),
            Expanded(
                child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return ignitionKey(user: users[index]);
              },
            ))
          ],
        )));
  }

  Widget ignitionLock() {
    return IconButton(
      onPressed: () {
        if (selectedUser != null) {
          dookieNotifier.selectUser(selectedUser!);
        }
      },
      icon: selectedUser != null
          ? Icon(
              Icons.lock_open,
              color: colorScheme.primary,
            )
          : Icon(
              Icons.lock,
              color: colorScheme.primary,
            ),
    );
  }

  Widget ignitionKey({required User user}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUser = user;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            Text(
              user.lastName,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            Icon(
              Icons.car_rental,
              color: colorScheme.onPrimary,
            )
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ColorScheme colorScheme;
  User? selectedUser;
  List users = DookieNotifier.users;
  late DookieNotifier dookieNotifier;
  var selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedPage) {
      case 0:
        // Normal View with buttons for controlling some aspects and the automated systems
        page = const Placeholder(text: 'Home');
        break;
      case 1:
        // Joystick view for controlling the car
        page = const Placeholder(text: 'Joystick View');
        break;
      case 2:
        // Dookie Clicker
        page = const DookieClicker();
        break;
      case 3:
        //
        page = const Placeholder(text: 'Car Customization');
        break;
      case 4:
        page = const Placeholder(text: 'Settings');
        break;
      default:
        page = const Placeholder(text: 'Info');
    }
    colorScheme = Theme.of(context).colorScheme;
    dookieNotifier = Provider.of<DookieNotifier>(context);
    return Stack(
      children: [
        Scaffold(
            key: _scaffoldKey,
            drawer: menuDrawer(),
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Dookie Controls"),
              leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: colorScheme.primary,
                ),
              ),
            ),
            body: page),
      ],
    );
  }

  Drawer menuDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Dookie Controls',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              setState(() {
                selectedPage = 0;
              });
            },
          ),
          ListTile(
            title: const Text('Joystick View'),
            onTap: () {
              setState(() {
                selectedPage = 1;
              });
            },
          ),
          ListTile(
            title: const Text('Dookie Clicker'),
            onTap: () {
              setState(() {
                selectedPage = 2;
              });
            },
          ),
          ListTile(
            title: const Text('Car Customization'),
            onTap: () {
              setState(() {
                selectedPage = 3;
              });
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              setState(() {
                selectedPage = 4;
              });
            },
          ),
          ListTile(
            title: const Text('Info'),
            onTap: () {
              setState(() {
                selectedPage = 5;
              });
            },
          ),
        ],
      ),
    );
  }
}

class Placeholder extends StatelessWidget {
  final String text;
  const Placeholder({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}

class DookieClicker extends StatefulWidget {
  const DookieClicker({super.key});

  @override
  State<DookieClicker> createState() => _DookieClickerState();
}

class _DookieClickerState extends State<DookieClicker> {
  late ColorScheme colorScheme;
  late DookieNotifier dookieNotifier;
  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    dookieNotifier = Provider.of<DookieNotifier>(context);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Container(
                child: Column(
              children: [
                const Text("Dookie Clicker"),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dookieNotifier.dookieAmount +=
                          1 * dookieNotifier.dookieMultiplier;
                    });
                  },
                  child: const Text("Click"),
                ),
                Text("${dookieNotifier.dookieAmount.toInt()} dookies"),
              ],
            )),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return upgradeButton(
                      name: "Upgrade 1", cost: 10, multiplier: 2);
                case 1:
                  return upgradeButton(
                      name: "Upgrade 2", cost: 100, multiplier: 5);
                case 2:
                  return upgradeButton(
                      name: "Upgrade 3", cost: 1000, multiplier: 10);
                default:
                  return const Text("Error");
              }
            },
          )),
        )
      ],
    );
  }

  Widget upgradeButton(
      {required String name,
      required double cost,
      required double multiplier}) {
    return ElevatedButton(
      onPressed: () {
        if (dookieNotifier.dookieAmount >= cost) {
          setState(() {
            dookieNotifier.dookieAmount -= cost;
            dookieNotifier.dookieMultiplier += multiplier;
          });
        }
      },
      child: Text("$name\nCost: $cost\nMultiplier: $multiplier"),
    );
  }
}
