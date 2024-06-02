import 'dart:io';

import 'package:dookie_controls/settings_menu.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dookie_controls/color_schemes/color_schemes.g.dart';
import 'package:dookie_controls/imports.dart';
import 'package:dookie_controls/dookie_notifier.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dookie_controls/dookie_clicker.dart';
import 'dart:async';
import 'dart:ui';

import 'package:dookie_controls/model_viewer.dart';
import 'package:dookie_controls/skibidi_opener.dart';
import 'package:dookie_controls/bluetooth_messenger.dart';
import 'package:dookie_controls/info_page.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    return ChangeNotifierProvider(
      create: (context) => DookieNotifier(),
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Dookie Controls',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
        home: const MyHomePage(title: 'Dookie Controls'),
        // home: BluetoothPage(),
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final refreshCompleter = Completer<void>();
  late final AnimationController _iconController;
  late ColorScheme colorScheme;
  User? selectedUser;
  List users = [];
  late Future<String> _initFuture;
  late DookieNotifier dn;

  final ValueNotifier<bool> _deleteMode = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    dn = Provider.of<DookieNotifier>(context);
    return loadingScreen();
  }

  @override
  void initState() {
    super.initState();
    var dookieNotifier = context.read<DookieNotifier>();
    _initFuture = dookieNotifier.readUsers();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _deleteMode.addListener(_handleDeleteModeChange);
  }

  void _handleDeleteModeChange() {
    if (_deleteMode.value) {
      _iconController.forward();
    } else {
      _iconController.reverse();
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await dn.readUsers();
  }

  Widget loadingScreen() {
    return FutureBuilder<String>(
      future: _initFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return shownScreen();
        }
      },
    );
  }

  Widget shownScreen() {
    if (dn.selectedUser != null) {
      return const MainPage();
    } else {
      return logInScreen();
    }
  }

  Widget logInScreen() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.secondaryContainer,
          title: Row(
            children: [
              Image.asset(
                'assets/icons/icon.png',
                height: 40,
              ),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: TextStyle(color: colorScheme.onSecondaryContainer),
              ),
            ],
          ),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 2, child: Container(child: ignitionLock())),
            Text(
              dn.users.isEmpty ? "" : "Select a user",
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
            Expanded(
              flex: 4,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  int crossAxisCount = constraints.maxWidth ~/
                      200; // Adjust the divisor to fit your needs
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (crossAxisCount > 1) ? crossAxisCount : 2,
                    ),
                    itemCount: dn.users.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (dn.users.isEmpty) {
                        return const SizedBox();
                      }
                      return ignitionKey(user: dn.users.values.toList()[index]);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                  color: colorScheme.secondaryContainer,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_deleteMode.value) {
                          nameController.clear();
                          lastNameController.clear();
                          selectedCarBrand = null;
                          addUserWindow();
                        } else {
                          setState(() {
                            _deleteMode.value = false;
                          });
                        }
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _deleteMode,
                        builder: (context, value, child) {
                          return AnimatedBuilder(
                            animation: _iconController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _iconController.value * pi / 4,
                                child: Icon(
                                  Icons.add,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              );
                            },
                          );
                        },
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
              scrollable: true,
              title: const Text('Add User'),
              content: SizedBox(
                height: 210,
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
                          requestFocusOnTap: false,
                          selectedTrailingIcon:
                              const Icon(Icons.arrow_drop_down),
                          dropdownMenuEntries: getCarBrands(),
                          menuHeight: 150,
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
                      dn.addUser(
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
      if (selectedUser!.carBrand.id == 5) {
        int randomNumber = Random().nextInt(10);
        int randomNumber2 = Random().nextInt(10);
        if (randomNumber == randomNumber2) {
          dn.selectUser(selectedUser!);
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
      } else if (selectedUser!.carBrand.id == 3) {
        buyDLCPopup();
      } else {
        dn.selectUser(selectedUser!);
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

  void buyDLCPopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              scrollable: true,
              title: const Text('Buy DLC'),
              content: const SizedBox(
                height: 210,
                child: Column(
                  children: [
                    Text(
                        'To Drive the Legendary Mercedes-Benz, you must buy the DLC for 9.99€ a Month.'),
                    Text('Do you want to buy the DLC?'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('HELL NAH')),
                TextButton(
                    onPressed: () async {
                      final Uri url =
                          Uri.parse('https://www.mercedes-benz.com/');
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    child: const Text('YES, I CLAIM!!!')),
              ],
            ),
          );
        });
  }

  Widget ignitionLock() {
    return Column(
      children: [
        Expanded(
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          ),
        ),
        if (selectedUser == null) const Expanded(child: SizedBox()),
        if (selectedUser != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        selectedUser!.carBrand.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
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
      onLongPress: () {
        setState(() {
          debugPrint('Long Pressed');
          _deleteMode.value = true;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Column(
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
            if (_deleteMode.value)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return deleteConfirmation(user);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  AlertDialog deleteConfirmation(User user) {
    return AlertDialog(
      title: const Text('Delete User'),
      content: Text('Are you sure you want to delete ${user.name}'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              dn.removeUser(user.id);
              if (dn.users.isEmpty) {
                setState(() {
                  _deleteMode.value = false;
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Delete')),
      ],
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
  late DookieNotifier dn;
  bool timerStarted = false;

  var selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    dn = Provider.of<DookieNotifier>(context);
    if (!dn.isTimerRunning && !timerStarted) {
      dn.startTimer();
      timerStarted = true;
    }
    Widget page;
    switch (selectedPage) {
      case 0:
        // Normal View with buttons for controlling some aspects and the automated systems
        page = const Connectionpage();
        break;
      case 1:
        // Joystick view for controlling the car
        page = const SkibidiOpener();
        break;
      case 2:
        // Dookie Clicker
        page = const DookieClicker();
        break;
      case 3:
        //
        page = const Dookie3DViewer();
        break;
      case 4:
        page = const SettingsMenu();
        break;
      default:
        page = const InfoPage();
    }
    colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        debugPrint('Popped Main Screen');
        if (!didPop) {
          dn.logout();
        }
      },
      child: Stack(
        children: [
          Scaffold(
              key: _scaffoldKey,
              drawer: menuDrawer(),
              appBar: AppBar(
                backgroundColor: colorScheme.secondaryContainer,
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/icon.png',
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Dookie Controls',
                      style: TextStyle(color: colorScheme.onSecondaryContainer),
                    ),
                  ],
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
                  Row(
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: dn.isConnected
                              ? Colors.green
                              : dn.isConnecting
                                  ? Colors.yellow
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(500),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          dn.logout();
                        },
                        icon: Icon(
                          Icons.logout,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: page),
        ],
      ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              children: [
                Text(
                  'Dookie Controls',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 24,
                  ),
                ),
                Image.asset(
                  'assets/icons/icon.png',
                  height: 100,
                )
              ],
            ),
          ),
          menuButton(
              title: "Home",
              index: 0,
              icon: Icons.home_outlined,
              iconSelected: Icons.home),
          menuButton(
              title: "Skibidi Opener",
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
  const Placeholder({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}
