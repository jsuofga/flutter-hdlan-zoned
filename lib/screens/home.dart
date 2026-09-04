import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hdlan_controller/custom/round_zone_button.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  void initState() {
    super.initState();
    Provider.of<ZoneNamesModel>(context, listen: false).getZoneInfo();
    Provider.of<UserInterfaceModel>(context, listen: false).getZoneToShow();
  }

  @override
  Widget build(BuildContext context) {
    final uiModel = Provider.of<UserInterfaceModel>(context);
    final zoneList = Provider.of<ZoneNamesModel>(context).zoneInfoList;
    final int effectiveZone = uiModel.allowedZone > 0 ? uiModel.allowedZone : uiModel.zoneToShow;

    List filteredZoneList = zoneList;
    if (effectiveZone > 0) {
      filteredZoneList = zoneList.where((item) => item.zoneID == effectiveZone).toList();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          zoneList.isEmpty
              ? const Text(
                  'Welcome. Goto Settings To Start',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                )
              : Wrap(
                  children: [
                    ...filteredZoneList
                        .map((item) => RoundZoneButton(
                            zoneID: item.zoneID, zoneLabel: item.zoneName))
                        .toList(),
                    if (effectiveZone == 0)
                      RoundZoneButton(zoneID: 99, zoneLabel: 'ALL'),
                  ],
                )
        ],
      ),
    );
  }
}
