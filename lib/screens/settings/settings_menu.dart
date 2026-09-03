import 'package:flutter/material.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:hdlan_controller/screens/settings/create_displays.dart';
import 'package:hdlan_controller/screens/settings/create_video_sources.dart';
import 'package:hdlan_controller/screens/settings/create_zone.dart';
import 'package:hdlan_controller/screens/settings/synch_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  String _model = '';

  @override
  void initState() {
    super.initState();
    Provider.of<ZoneNamesModel>(context, listen: false).getZoneInfo();
    Provider.of<DisplayInfoModel>(context, listen: false).getDisplayInfo();
    _readFromStorage();
  }

  //Read from storage
  void _readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _model = prefs.getString('model') ?? 'not detected';
    });
  }

  void showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.amber, size: 50),
              Text("Important"),
            ],
          ),
          content: const Text("Please re-power Cisco switch before Synchronizing switch"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<UserInterfaceModel>(context, listen: false).showIP();
                  showPage(const SynchSwitch());
                },
                child: const Text("Ok- I will")),
          ],
        );
      },
    );
  }

  // Bottom Sheet Modal - Admin and Settings
  void showPage(_page) {
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        minWidth: double.infinity,
      ),
      context: context,
      builder: (context) {
        final height100vh = MediaQuery.of(context).size.height;

        return Container(
          height: height100vh,
          width: double.infinity,
          color: Colors.white,
          child: _page,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  showAlert();
                },
                label: const Text('Synch Switch'),
                icon: const Icon(Icons.router),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _model != 'not detected',
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showPage(const CreateZone());
                  },
                  label: const Text('Add Zones'),
                  icon: const Icon(Icons.workspaces_filled),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: Provider.of<ZoneNamesModel>(context).zoneInfoList.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showPage(const CreateDisplays());
                  },
                  label: const Text('Add Displays'),
                  icon: const Icon(Icons.tv),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _model != 'not detected',
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showPage(const CreateVideoSources());
                  },
                  label: const Text('Add Video Sources'),
                  icon: const Icon(Icons.settings_input_hdmi_outlined),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<UserInterfaceModel>(context, listen: false)
                      .hideSelectSettingsMenu();
                  Navigator.pop(context);
                },
                label: const Text('CANCEL'),
                icon: const Icon(Icons.cancel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
