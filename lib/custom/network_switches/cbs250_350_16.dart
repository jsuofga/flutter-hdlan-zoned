import 'package:flutter/material.dart';
import 'package:hdlan_controller/custom/network_switches/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';


class CBS_250_350_16port extends StatefulWidget {
  const CBS_250_350_16port({Key? key}) : super(key: key);

  @override
  _CBS_250_350_16portState createState() => _CBS_250_350_16portState();
}

class _CBS_250_350_16portState extends State<CBS_250_350_16port> {
  List oddPorts =  [1,3,5,7,9,11,13,15];
  List evenPorts = [2,4,6,8,10,12,14,16];

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
                    ],
                ),
                TableRow(
                    children:  [
                      ...evenPorts.map((item) => Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[item-1] == 1? 1:0.5,child: Icon(Icons.inbox,color:Provider.of<SnmpModel>(context).portColors[item-1],)),Text(item.toString())])).toList(),
                      Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[16] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[16],)),Text('17SFP')]),
                      Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[17] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[17],)),Text('18SFP')]),
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
