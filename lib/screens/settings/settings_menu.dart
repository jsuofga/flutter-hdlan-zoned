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
    Provider.of<ZoneNamesModel>(context,listen: false).getZoneInfo();
    Provider.of<DisplayInfoModel>(context,listen: false).getDisplayInfo();
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
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning,color: Colors.amber,size: 50,),
            Text("Important"),
          ],
        ),
        content: Text("Please re-power Cisco switch before Synchronizing switch"),
        actions: [
          ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
                showPage(SynchSwitch());
              },
              child: Text("Ok- I will")),
        ],
      );

    });
  }

  // Bottom Sheet Modal - Admin and Settings
 void showPage(_page) {
   showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
     return Container(
       padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
       child:_page,
       // child: Provider.of<UserInterfaceModel>(context).showAdminAccess ? AdminAccess():SettingsMenu()
     );
   });
   // }).whenComplete(() => Provider.of<UserInterfaceModel>(context,listen: false).hideIP() );
 }

  @override
    Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: (){
                      showAlert();
                    },
                    label: Text('Synch Switch'),
                    icon: Icon(Icons.router),
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.green,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ),
                )),
          ),
          Visibility(
            visible: _model != 'not detected',
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  child: SizedBox(
                    width:350,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: (){
                        Navigator.pop(context);
                        showPage(CreateZone());
                        },
                      label: Text('Add Zones'),
                      icon: Icon(Icons.workspaces_filled),
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.green,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          Visibility(
            visible:  Provider.of<ZoneNamesModel>(context).zoneInfoList.length > 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  child: SizedBox(
                    width:350,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: (){
                        Navigator.pop(context);
                        showPage(CreateDisplays());
                                           },
                      label: Text('Add Displays'),
                      icon: Icon(Icons.tv),
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.green,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: _model != 'not detected',
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  child: SizedBox(
                    width:350,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: (){
                        Navigator.pop(context);
                        showPage(CreateVideoSources());
                      },
                      label: Text('Add Video Sources'),
                      icon: Icon(Icons.settings_input_hdmi_outlined),
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.green,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                child: SizedBox(
                  width:350,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: (){
                      Provider.of<UserInterfaceModel>(context,listen: false).hideSelectSettingsMenu();
                      Navigator.pop(context);
                    },
                    label: Text('CANCEL'),
                    icon: Icon(Icons.cancel),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ),
                )),
          ),

        ],
      ),
    );
  }
}
