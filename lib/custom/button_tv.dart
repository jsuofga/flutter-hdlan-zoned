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
    final snmpModel = Provider.of<SnmpModel>(context);
    final int targetIndex = _txCount + widget.rxID - 1;
    String _vlanMembership = '1';
    if (snmpModel.vlanMembership.isNotEmpty && targetIndex >= 0 && targetIndex < snmpModel.vlanMembership.length) {
      _vlanMembership = snmpModel.vlanMembership[targetIndex];
    }
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
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.white,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(6.0),
                           ),
                         ),
                         child: Text('${widget.displayName}',style:TextStyle(color:Colors.black)),
                        ),
                 ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: Text('P${widget.rxID + _txCount}', style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                )
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

