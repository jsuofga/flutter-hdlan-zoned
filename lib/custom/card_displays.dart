import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CardDisplay extends StatefulWidget {
  int zoneID ;
  int rxID;
  String zoneName = '';
  String displayName = '';

  //Constructor
  CardDisplay({required this.zoneID,required this.rxID,required this.zoneName,required this.displayName });

  @override
  State<CardDisplay> createState() => _CardDisplayState();
}

class _CardDisplayState extends State<CardDisplay> {
 int _txCount = 0;

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
    TextEditingController textController = TextEditingController();
    textController.text = widget.displayName;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Port ${widget.rxID+_txCount} ',style: TextStyle(color:Colors.black45,),),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () {
                       Provider.of<DisplayInfoModel>(context,listen: false).deleteDisplay(widget.zoneID);
                      setState(() {

                      });
                    },
                  ),

                ],
              ),
              Text(widget.zoneName,style: TextStyle(color:Colors.black45,height: 2)),
              TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5.0, top: 10.0, bottom: 0.0),
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),

                      ),
                      hintText: 'Display Name',
                      labelText: ''
                  ),
                  onChanged: (val){
                    // print(textController.text);
                    Provider.of<DisplayInfoModel>(context,listen: false).editDisplayName(widget.rxID, textController.text);

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
