import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';


class RadioButtonDisplay extends StatefulWidget {
  int zoneID ;
  String zoneName = '';

  //Constructor
  RadioButtonDisplay({required this.zoneID,required this.zoneName });

  @override
  State<RadioButtonDisplay> createState() => _RadioButtonDisplayState();
}

class _RadioButtonDisplayState extends State<RadioButtonDisplay> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      child:
        Row(
          children: [
            Radio(
                value: widget.zoneID,
                groupValue: 1,
                onChanged: (value){
                   // Provider.of<DisplayInfoModel>(context,listen: false).setZoneSelectedValue(widget.zoneID) ;
                    setState(() {


                    });
                }),
            Text(widget.zoneName),
          ],
        ),

    );

  }
}


