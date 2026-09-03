import 'package:flutter/material.dart';
import 'package:hdlan_controller/class_models.dart';
import 'package:hdlan_controller/custom/button_tv.dart';
import 'package:hdlan_controller/custom/video_select_panel.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';

class Zones extends StatefulWidget {
  const Zones ({Key? key}) : super(key: key);
  @override
  _Zones  createState() => _Zones ();
}

class _Zones  extends State<Zones> {
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

  void initState() {
    super.initState();
    Provider.of<DisplayInfoModel>(context,listen: false).getDisplayInfo();

  }
  @override
  Widget build(BuildContext context) {

     int _zoneIndex = Provider.of<UserInterfaceModel>(context).zoneToShow - 1;
     List _allDisplays = Provider.of<DisplayInfoModel>(context).displayInfoList;
     List _displaysInThisZone= _allDisplays.where((item) => item.zoneID == _zoneIndex+1 ).toList();
    return Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                 // child: Text('${Provider.of<ZoneNamesModel>(context).zoneInfoList[_zoneIndex].zoneName}', style:TextStyle(color:Colors.white,fontSize: 50),),
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2c3e50)),
                   child:Text('${Provider.of<ZoneNamesModel>(context).zoneInfoList[_zoneIndex].zoneName}', style:TextStyle(color:Colors.white,fontSize: 40)),
                   onPressed: (){
                     showVideoSelectPanel();
                     Provider.of<SwitchingModel>(context,listen:false).selectZone(_zoneIndex+1);

                   },
                 ),

              ),
            ],
          ),

          Wrap(
            children:_displaysInThisZone.map((item) => ButtonTV(rxID:item.rxID,displayName: item.displayName,)).toList(),
          )
        ],

    );
  }
}

