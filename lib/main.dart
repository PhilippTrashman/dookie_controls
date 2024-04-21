import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dookie_controls/color_schemes/color_schemes.g.dart';
import 'package:dookie_controls/imports.dart';
import 'package:dookie_controls/dookie_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dookie_controls/dookie_clicker.dart';

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
  List users = [];
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
          backgroundColor: colorScheme.secondaryContainer,
          title: Text(
            widget.title,
            style: TextStyle(color: colorScheme.onSecondaryContainer),
          ),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 2, child: Container(child: ignitionLock())),
            Text(
              dookieNotifier.users.isEmpty ? "" : "Select a user",
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
            Expanded(
                flex: 4,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: dookieNotifier.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (dookieNotifier.users.isEmpty) {
                      return const SizedBox();
                    }
                    return ignitionKey(user: dookieNotifier.users[index]!);
                  },
                )),
            Expanded(
              child: Container(
                  color: colorScheme.secondaryContainer,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        nameController.clear();
                        lastNameController.clear();
                        selectedCarBrand = null;
                        addUserWindow();
                      },
                      child: Icon(
                        Icons.add,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  )),
            )
          ],
        )));
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  CarBrand? selectedCarBrand;
  CarBrand? selectedCarBrand2;

  List<DropdownMenuEntry<CarBrand>> getCarBrands() {
    List<DropdownMenuEntry<CarBrand>> result = [];
    for (var carBrand in carBrands.values) {
      result.add(DropdownMenuEntry(
        value: carBrand,
        label: carBrand.name,
      ));
    }
    return result;
  }

  void addUserWindow() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Add User'),
              content: Container(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      controller: nameController,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      controller: lastNameController,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownMenu(
                          label: const Text('Car Brand'),
                          dropdownMenuEntries: getCarBrands(),
                          expandedInsets:
                              const EdgeInsets.symmetric(vertical: 5.0),
                          onSelected: (value) {
                            setState(() {
                              selectedCarBrand = value;
                            });
                          },
                        )),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          lastNameController.text.isEmpty ||
                          selectedCarBrand == null) {
                        return;
                      }
                      dookieNotifier.addUser(
                          name: nameController.text,
                          lastName: lastNameController.text,
                          carBrand: selectedCarBrand!);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add User')),
              ],
            ),
          );
        });
  }

  void login() {
    if (selectedUser != null) {
      if (selectedUser!.carBrand.name == '狗屎盒') {
        int randomNumber = Random().nextInt(10);
        int randomNumber2 = Random().nextInt(10);
        if (randomNumber == randomNumber2) {
          dookieNotifier.selectUser(selectedUser!);
          selectedUser = null;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('User Selected'),
              ),
            );
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Engine Stalled'),
              ),
            );
        }
      } else {
        dookieNotifier.selectUser(selectedUser!);
        selectedUser = null;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('User Selected'),
            ),
          );
      }
    }
  }

  Widget ignitionLock() {
    return Column(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            onPressed: login,
            child: selectedUser != null
                ? Icon(
                    Icons.lock_open,
                    color: colorScheme.onPrimaryContainer,
                  )
                : Icon(
                    Icons.lock,
                    color: colorScheme.onPrimaryContainer,
                  ),
          ),
        ),
        if (selectedUser != null)
          Expanded(
            child: SvgPicture.asset(
              selectedUser!.carBrand.logo,
              fit: BoxFit.contain,
            ),
          ),
      ],
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
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
            Text(
              user.lastName,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
            Expanded(
              child: SvgPicture.asset(
                user.carBrand.logo,
                fit: BoxFit.contain,
              ),
            ),
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
  List users = [];
  late DookieNotifier dookieNotifier;
  bool timerStarted = false;

  var selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    dookieNotifier = Provider.of<DookieNotifier>(context);
    if (!dookieNotifier.isTimerRunning && !timerStarted) {
      dookieNotifier.startTimer();
      timerStarted = true;
    }
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

    return Stack(
      children: [
        Scaffold(
            key: _scaffoldKey,
            drawer: menuDrawer(),
            appBar: AppBar(
              backgroundColor: colorScheme.secondaryContainer,
              title: Text(
                "Dookie Controls",
                style: TextStyle(color: colorScheme.onSecondaryContainer),
              ),
              leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: colorScheme.primary,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    dookieNotifier.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            body: page),
      ],
    );
  }

  ListTile menuButton(
      {required String title,
      required int index,
      required IconData icon,
      required IconData iconSelected}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSecondaryContainer),
      ),
      leading: Icon(
        selectedPage == index ? iconSelected : icon,
        color: colorScheme.onSecondaryContainer,
      ),
      onTap: () {
        setState(() {
          selectedPage = index;
        });
      },
    );
  }

  Drawer menuDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Text(
              'Dookie Controls',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: 24,
              ),
            ),
          ),
          menuButton(
              title: "Home",
              index: 0,
              icon: Icons.home_outlined,
              iconSelected: Icons.home),
          menuButton(
              title: "Joystick View",
              index: 1,
              icon: Icons.sports_esports_outlined,
              iconSelected: Icons.sports_esports),
          menuButton(
              title: "Dookie Clicker",
              index: 2,
              icon: Icons.payments_outlined,
              iconSelected: Icons.payments),
          menuButton(
              title: "Car Customization",
              index: 3,
              icon: Icons.car_rental_outlined,
              iconSelected: Icons.car_rental),
          menuButton(
              title: "Settings",
              index: 4,
              icon: Icons.settings_outlined,
              iconSelected: Icons.settings),
          menuButton(
              title: "Info",
              index: 5,
              icon: Icons.info_outline,
              iconSelected: Icons.info),
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
