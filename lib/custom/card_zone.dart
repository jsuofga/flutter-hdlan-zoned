import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';


class CardZone extends StatefulWidget {
  int zoneID ;
  String zoneName = '';

  //Constructor
  CardZone({required this.zoneID,required this.zoneName });

  @override
  State<CardZone> createState() => _CardZoneState();
}

class _CardZoneState extends State<CardZone> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    TextEditingController textController = TextEditingController();
    textController.text = widget.zoneName;
    textController.selection = TextSelection(
        baseOffset: textController.text.length,
        extentOffset: textController.text.length
    );

    return Card(
      child: Column(
        children: [
          Column(
            children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text('Zone ${widget.zoneID}',style: TextStyle(color:Colors.black45),),
                   IconButton(
                     icon: const Icon(Icons.delete_forever),
                     onPressed: () {
                        Provider.of<ZoneNamesModel>(context,listen: false).deleteZone(widget.zoneID);
                       setState(() {

                       });
                     },
                   ),

                 ],
               ),
              TextFormField(
                  //initialValue: Provider.of<ZoneNamesModel>(context).zoneInfoList[widget.zoneID-1].zoneName,
                  controller: textController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)
                  ),
                      hintText: 'Zone Name',
                      labelText: ''
                  ),
                  onChanged: (val){
                    // print(textController.text);
                    Provider.of<ZoneNamesModel>(context,listen: false).editZoneName(widget.zoneID, textController.text);
                  },
                  validator: (val) {

                  }
              ),

            ],

          ),
        ],
      ),
    );
  }
}
