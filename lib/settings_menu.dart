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
    return Container(
      child: Column(
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
            title: const Text('Version'),
            trailing: const Text('0.0.1'),
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
      ),
    );
  }

  List<Widget> _userTiles() {
    return [
      ListTile(
        title: Text('Option 1'),
        onTap: () {},
      ),
      ListTile(
        title: Text('Option 2'),
        onTap: () {},
      ),
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
    ];
  }
}
