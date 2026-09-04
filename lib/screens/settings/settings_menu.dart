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
  int? _selectedZoneID;

  @override
  void initState() {
    super.initState();
    Provider.of<ZoneNamesModel>(context, listen: false).getZoneInfo();
    Provider.of<DisplayInfoModel>(context, listen: false).getDisplayInfo();
    Provider.of<UserInterfaceModel>(context, listen: false).getZoneToShow();
    _readFromStorage();
  }

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
    final zoneList = Provider.of<ZoneNamesModel>(context).zoneInfoList;
    final uiModel = Provider.of<UserInterfaceModel>(context);

    int activeZoneID = _selectedZoneID ?? uiModel.allowedZone;

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Provider.of<UserInterfaceModel>(context, listen: false)
                        .hideSelectSettingsMenu();
                    Navigator.pop(context);
                  },
                ),
              ),
              const Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
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
                    visible: zoneList.isNotEmpty,
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
                  if (zoneList.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0, bottom: 4.0),
                            child: Text(
                              'Allow Tablet to control:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          RadioListTile<int>(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                            title: const Text(
                              'ALL Zones',
                              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            value: 0,
                            groupValue: activeZoneID,
                            onChanged: (int? value) {
                              if (value != null) {
                                setState(() {
                                  _selectedZoneID = value;
                                });
                                Provider.of<UserInterfaceModel>(context, listen: false).setAllowedZone(0);
                              }
                            },
                          ),
                          ...zoneList.map((zone) {
                            return RadioListTile<int>(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              title: Text(
                                'Zone ${zone.zoneID}: ${zone.zoneName}',
                                style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                              value: zone.zoneID as int,
                              groupValue: activeZoneID,
                              onChanged: (int? value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedZoneID = value;
                                  });
                                  Provider.of<UserInterfaceModel>(context, listen: false).setAllowedZone(value);
                                }
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
