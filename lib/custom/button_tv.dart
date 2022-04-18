import 'package:flutter/material.dart';
import 'package:hdlan_controller/custom/video_select_panel.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonTV extends StatefulWidget {
  int rxID ;
  String displayName = '';

  //Constructor
  // ButtonTV({required this.zoneID,required this.displayName });
  ButtonTV({required this.rxID,required this.displayName });

  @override
  _ButtonTVState createState() => _ButtonTVState();
}

class _ButtonTVState extends State<ButtonTV> {
  int _txCount = 0;

  // Bottom Sheet Modal - Admin and Settings
  void showVideoSelectPanel() {
    showModalBottomSheet(isScrollControlled: false,context: context, builder: (context){
      return Container(

        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
        child:VideoSelectPanel(),
        // child: Provider.of<UserInterfaceModel>(context).showAdminAccess ? AdminAccess():SettingsMenu()
      );
    });
    // }).whenComplete(() => Provider.of<UserInterfaceModel>(context,listen: false).hideIP() );
  }

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
    Provider.of<SourceNamesModel>(context,listen: false).getSourceInfo();
    _readFromStorage();
  }
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    String _vlanMembership = Provider.of<SnmpModel>(context).vlanMembership[_txCount + widget.rxID -1];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8,50,8,0),
          child:Stack(
            children: [
               SizedBox(
                 width:screenSize.width / 12,
                 child: ElevatedButton(
                         onPressed: (){
                           Provider.of<SwitchingModel>(context,listen: false).selectPort((_txCount + widget.rxID).toString());
                           Provider.of<SwitchingModel>(context,listen: false).selectZone(0) ;
                           showVideoSelectPanel();
                         },
                         style: ElevatedButton.styleFrom(primary: Colors.white),
                         child: Text('${widget.displayName}',style:TextStyle(color:Colors.black)),
                        ),
                 ),
                Positioned(child: Text('P${widget.rxID + _txCount }',style:TextStyle(fontSize:10,color:Colors.black)),top:8 ,right:5)
            ],
          )
        ),
        // FeedBack
        //   Text('${Provider.of<SourceNamesModel>(context).sourceInfoList[int.parse(_vlanMembership)-2].sourceName}',style:TextStyle(color:Colors.white))
            Text('${Provider.of<SourceNamesModel>(context).sourceInfoList.length> 0 ? Provider.of<SourceNamesModel>(context).sourceInfoList[int.parse(_vlanMembership)-2].sourceName :''}',
                  style:TextStyle(color:Colors.white))
      //

      ],
    );
  }
}

