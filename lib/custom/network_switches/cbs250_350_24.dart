import 'package:flutter/material.dart';
import 'package:hdlan_controller/custom/network_switches/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CBS_250_350_24port extends StatefulWidget {
  const CBS_250_350_24port({Key? key}) : super(key: key);
  @override
  _CBS_250_350_24portState createState() => _CBS_250_350_24portState();
}

class _CBS_250_350_24portState extends State<CBS_250_350_24port> {
   List oddPorts =  [1,3,5,7,9,11,13,15,17,19,21,23];
   List evenPorts = [2,4,6,8,10,12,14,16,18,20,22,24];

  @override
  Widget build(BuildContext context) {

    return    Provider.of<SnmpModel>(context).portColors.isEmpty ? Container(child:Text('Detecting Switch')) : Container(
      child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Table(
                  border: TableBorder(
                  top:BorderSide(color:Colors.black,width: 3),
                  bottom:BorderSide(color:Colors.black,width: 3),
                  left:BorderSide(color:Colors.black,width: 3),
                  right:BorderSide(color:Colors.black,width: 3),
                  horizontalInside: BorderSide(color:Colors.black,width: 1),
                  verticalInside: BorderSide(color:Colors.black,width: 1)

                ),
                  children: [
                      TableRow(
                        children:  [
                          ...oddPorts.map((item) => Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[item-1] == 1? 1:0.5,child: Icon(Icons.inbox,color:Provider.of<SnmpModel>(context).portColors[item-1],)),Text(item.toString())])).toList(),
                          Column(children: []),
                          Column(children: []),
                          Column(children: []),
                          Column(children: []),

                        ],
                      ),
                      TableRow(
                        children:  [
                          ...evenPorts.map((item) => Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[item-1] == 1? 1:0.5,child: Icon(Icons.inbox,color:Provider.of<SnmpModel>(context).portColors[item-1],)),Text(item.toString())])).toList(),
                          Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[24] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[24],)),Text('25SFP')]),
                          Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[25] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[25],)),Text('26SFP')]),
                          Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[26] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[26],)),Text('27SFP')]),
                          Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[27] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[27],)),Text('28SFP')]),

                        ]
                      ),
                    ],
                  ),
                  Dashboard()
              ],
            )
    );
  }
}


