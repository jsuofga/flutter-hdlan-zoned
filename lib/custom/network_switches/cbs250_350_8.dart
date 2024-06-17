import 'package:flutter/material.dart';
import 'package:hdlan_controller/custom/network_switches/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';


class CBS_250_350_8port extends StatefulWidget {
  const CBS_250_350_8port({Key? key}) : super(key: key);

  @override
  _CBS_250_350_8portState createState() => _CBS_250_350_8portState();
}

class _CBS_250_350_8portState extends State<CBS_250_350_8port> {
  List oddPorts =  [1,2,3,4,5,6,7,8,9,10];

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
                    // Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[9] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[9],)),Text('9SFP')]),
                    // Column(children: [Opacity(opacity:Provider.of<SnmpModel>(context).portStatus[10] == 1? 1:0.5,child: Icon(Icons.center_focus_weak_rounded ,color: Provider.of<SnmpModel>(context).portColors[10],)),Text('10SFP')]),

                  ],
                ),

              ],
            ),
            Dashboard()
          ],
        )
    );
  }

}
