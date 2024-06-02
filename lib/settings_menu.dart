import 'package:dookie_controls/dookie_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  late DookieNotifier _dn;
  // ignore: unused_field
  late ColorScheme _colorScheme;
  int _tapAmount = 0;

  Widget getTwerkingThanos(bool condition) {
    if (condition) {
      return Image.asset('assets/images/twerking_thanos.gif');
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    _dn = Provider.of<DookieNotifier>(context);
    _colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: getTwerkingThanos(_dn.selectedUser!.devMode),
                    ),
                  ),
                  Expanded(child: Image.asset('assets/icons/icon.png')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: getTwerkingThanos(_dn.selectedUser!.devMode),
                    ),
                  ),
                ],
              )),
        ),
        Expanded(
          flex: 4,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Divider(),
              ..._userTiles(),
              const Divider(),
              if (_dn.selectedUser!.devMode) ..._devWidgets(),
            ],
          ),
        ),
        ListTile(
          title: const Text(''),
          trailing: const Text('V.0.0.1'),
          onTap: () {
            setState(() {
              _tapAmount++;
              if (_tapAmount == 10) {
                _dn.selectedUser!.devMode = true;
                _tapAmount = 0;
              }
            });
          },
        ),
      ],
    );
  }

  List<Widget> _userTiles() {
    return [
      ListTile(
        title: const Text('Reset Dookie Clicker'),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Reset Dookie Clicker'),
                  content: const Text(
                      'Are you sure you want to reset your progress?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _dn.resetDookieSave();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              });
        },
      ),
      ListTile(
        title: const Text('Reset Gacha'),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Reset Gacha'),
                  content: const Text(
                      'Are you sure you want to reset your gacha progress?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _dn.resetGachaSave();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              });
        },
      ),
      ListTile(
        title: const Text('Reset Skins'),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Reset Skins'),
                  content: const Text(
                      'Are you sure you want to reset your unlocked skins?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _dn.resetUnlockedSkins();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              });
        },
      )
    ];
  }

  List<Widget> _devWidgets() {
    return [
      ListTile(
        title: const Text('Disable Dev Mode'),
        onTap: () {
          setState(() {
            _dn.selectedUser!.devMode = false;
            _dn.selectedUser!.isCheater = false;
          });
        },
      ),
      ListTile(
          title: Text(_dn.selectedUser!.isCheater
              ? 'Disable Cheater Mode'
              : 'Enable Cheater Mode'),
          trailing: Switch(
            value: _dn.selectedUser!.isCheater,
            onChanged: (value) {
              setState(() {
                _dn.selectedUser!.isCheater = value;
              });
            },
          )),
      ListTile(
          title: Text("Dookie Cheater"),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController _controller =
                      TextEditingController();
                  return AlertDialog(
                    title: const Text("Dookie Cheater"),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: "Amount",
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _controller.text = value;
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                debugPrint(_controller.text);
                                _dn.addDookies(double.parse(_controller.text));
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                });
          }),
    ];
  }
}
