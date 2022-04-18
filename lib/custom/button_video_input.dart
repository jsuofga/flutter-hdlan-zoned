import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hdlan_controller/class_models.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoInputButton extends StatefulWidget {
  //constructor
  String videoInputLabel  ;
  int inputVlan  ;

  VideoInputButton({
    required  this.videoInputLabel,
    required  this.inputVlan,
  });

  @override
  State<VideoInputButton> createState() => _VideoInputButtonState();
}

class _VideoInputButtonState extends State<VideoInputButton> {
  bool hasBeenPressed = false;
  int  _txCount = 0;

  //Read from storage
  void _readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _txCount = prefs.getInt('txCount') ?? 0;

    });
  }
  @override
  void initState() {
    super.initState();
     _readFromStorage();
  }
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: SizedBox(
        width: screenSize.width/10,
        child: TextButton.icon(
          icon: Icon(Icons.input,
            color: Colors.black45,
          ),
          label: Text(
            widget.videoInputLabel,
            style: TextStyle(
                color:Colors.black,
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide( color:hasBeenPressed ? Colors.orange:Colors.black,width: 2),
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              hasBeenPressed = !hasBeenPressed;
            });
            Future.delayed(const Duration(seconds: 3), () {
              setState(() {
                hasBeenPressed = !hasBeenPressed;
              });

            });
            await Provider.of<SwitchingModel>(context,listen: false).selectInput(widget.inputVlan);
            String ip =  await Provider.of<SwitchingModel>(context,listen: false).getIPAddressMDFSwitch();

            if(await Provider.of<SwitchingModel>(context,listen: false).zoneSelect == 0 ){
              //no zone select mode
              print('switch normal');
              CiscoSmbSwitch(ipAddress: ip).connect({
                //
                'interfaceType': Provider.of<SwitchingModel>(context,listen: false).port.contains('-') ? 'interface range':'interface',
                'gi': Provider.of<SwitchingModel>(context,listen: false).port,
                'switchportType':'switchport access',
                'vlan':Provider.of<SwitchingModel>(context,listen: false).vlan
              });
            }else{
              // switch all RX in zone mode
              print('switch all in ZONE');
              List displays = Provider.of<DisplayInfoModel>(context,listen: false).displayInfoList; // get displayInfoList
              List displaysInZone = displays.where((item) => item.zoneID == Provider.of<SwitchingModel>(context,listen: false).zoneSelect ).toList(); // filter displayInfo that are in the zone selected
              List RXsInZone = displaysInZone.map((item) => item.rxID).toList();// Get rxID of all displays in this zone.
              CiscoSmbSwitch(ipAddress: ip).connectSwitchAllInZone(RXsInZone,{'txCount': _txCount,'vlan':widget.inputVlan});


            }
          },
        ),
      ),
    );
  }
}
