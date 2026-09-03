import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';

class CardVideoSource extends StatefulWidget {
  int sourceID;
  String sourceName = '';

  //Constructor
  CardVideoSource({required this.sourceID, required this.sourceName});

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
    TextEditingController textController = TextEditingController();
    textController.text = widget.sourceName;
    textController.selection = TextSelection(
        baseOffset: textController.text.length,
        extentOffset: textController.text.length
    );

    return Card(
      margin: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Positioned(
            top: 2,
            left: 4,
            child: Text(
              'Video In ${widget.sourceID}',
              style: const TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 1,
            right: 1,
            child: InkWell(
              onTap: () {
                Provider.of<SourceNamesModel>(context, listen: false).deleteSource(widget.sourceID);
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(Icons.delete_forever, color: Colors.red, size: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 20.0, 6.0, 6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 2.0, top: 0.0, bottom: 0.0),
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Video Source Name',
                      labelText: '',
                    ),
                    onChanged: (val) {
                      Provider.of<SourceNamesModel>(context, listen: false)
                          .editSourceName(widget.sourceID, textController.text);
                    },
                    validator: (val) {}
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
