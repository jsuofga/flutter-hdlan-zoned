import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hdlan_controller/custom/round_zone_button.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home ({Key? key}) : super(key: key);

  @override
  _Home  createState() => _Home ();
}

class _Home  extends State<Home> {

  @override
  void initState() {
    super.initState();
    Provider.of<ZoneNamesModel>(context,listen: false).getZoneInfo();
  }

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Provider.of<ZoneNamesModel>(context).zoneInfoList.length == 0 ?
          Text('Welcome. Goto Settings To Start',style:TextStyle(fontSize:50,color:Colors.white)):
          Wrap(
             children:[...Provider.of<ZoneNamesModel>(context).zoneInfoList.map((item) => RoundZoneButton(zoneID:item.zoneID,zoneLabel:item.zoneName)).toList(), RoundZoneButton(zoneID:99,zoneLabel:'ALL')],
          )
        ],
      ),

    );
  }
}


