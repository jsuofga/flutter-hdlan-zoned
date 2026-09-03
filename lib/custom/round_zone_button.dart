import 'package:flutter/material.dart';
import 'package:hdlan_controller/custom/video_select_panel.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoundZoneButton extends StatefulWidget {
  int zoneID = 1;
  String zoneLabel = '';
  //Constructor
  RoundZoneButton({ required this.zoneID, required this.zoneLabel });

  @override
  State<RoundZoneButton> createState() => _RoundZoneButtonState();
}

class _RoundZoneButtonState extends State<RoundZoneButton> {
   int _txCount = 0;
   int _rxCount = 0;
  //Read from storage
  void _readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _txCount = prefs.getInt('txCount') ?? 0;
      _rxCount = prefs.getInt('rxCount') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SourceNamesModel>(context,listen: false).getSourceInfo();
    _readFromStorage();
  }

  // Bottom Sheet Modal - Admin and Settings
  void showVideoSelectPanel() {
    showModalBottomSheet(
      isScrollControlled: true,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        minWidth: double.infinity,
      ),
      context: context,
      builder: (context) {
        final height80vh = MediaQuery.of(context).size.height * 0.8;
        return Container(
          height: height80vh,
          width: double.infinity,
          color: Colors.white,
          child: const VideoSelectPanel(),
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 150.0,
        height: 150.0,
        child: RawMaterialButton(
          onPressed: () {
            if(widget.zoneID != 99){
              Provider.of<UserInterfaceModel>(context,listen: false).setZoneToShow(widget.zoneID);
            }else{
               // ALL Selected
              Provider.of<SwitchingModel>(context,listen: false).selectPort('${_txCount + 1 }-${_txCount + _rxCount}');
              Provider.of<SwitchingModel>(context,listen: false).selectZone(0) ;
              showVideoSelectPanel();
            }

          },
           fillColor: Color(0xFF2c3e50),
          child: Text(widget.zoneLabel, style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20.0, color: Colors.white),
          ),
          shape: CircleBorder(),
        ),

      ),
    );
  }
}
