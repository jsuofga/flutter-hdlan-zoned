import 'package:flutter/material.dart';
import 'package:hdlan_controller/custom/network_switches/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';

class CBS_250_350_48port extends StatefulWidget {
  const CBS_250_350_48port({Key? key}) : super(key: key);

  @override
  _CBS_250_350_48portState createState() => _CBS_250_350_48portState();
}

class _CBS_250_350_48portState extends State<CBS_250_350_48port> {
  List oddPorts =  [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47];
  List evenPorts = [2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48];

  @override
  Widget build(BuildContext context) {
    List portColors = [Colors.green];

    return  Provider.of<SnmpModel>(context).portColors.isEmpty ? Container(child:Text('Detecting Switch')) : Container(
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
                    Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[48] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[48],)),Text('49SFP')]),
                    Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[50] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[50],)),Text('51SFP')]),

                  ],
                ),
                TableRow(
                    children:  [
                      ...evenPorts.map((item) => Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[item-1] == 1? 1:0.5,child: Icon(Icons.inbox,color:Provider.of<SnmpModel>(context).portColors[item-1],)),Text(item.toString())])).toList(),
                      Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[49] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[49],)),Text('50SFP')]),
                      Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[51] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[51],)),Text('52SFP')]),

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


