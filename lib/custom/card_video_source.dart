import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';


class CardVideoSource extends StatefulWidget {
  int sourceID ;
  String sourceName = '';

  //Constructor
  CardVideoSource({required this.sourceID,required this.sourceName });

  @override
  State<CardVideoSource> createState() => _CardVideoSourceState();
}

class _CardVideoSourceState extends State<CardVideoSource> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    TextEditingController textController = TextEditingController();
    textController.text = widget.sourceName;
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
                  Text('Video In ${widget.sourceID}',style: TextStyle(color:Colors.black45),),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () {
                      Provider.of<SourceNamesModel>(context,listen: false).deleteSource(widget.sourceID);
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
                      hintText: 'Video Source Name',
                      labelText: ''
                  ),
                  onChanged: (val){
                    // print(textController.text);
                    Provider.of<SourceNamesModel>(context,listen: false).editSourceName(widget.sourceID, textController.text);
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
