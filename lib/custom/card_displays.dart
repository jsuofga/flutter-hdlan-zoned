import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardDisplay extends StatefulWidget {
  int zoneID;
  int rxID;
  String zoneName = '';
  String displayName = '';

  //Constructor
  CardDisplay({required this.zoneID, required this.rxID, required this.zoneName, required this.displayName});

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
    Provider.of<SourceNamesModel>(context, listen: false).getSourceInfo();
    _readFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    textController.text = widget.displayName;
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
              'Port ${widget.rxID + _txCount}',
              style: const TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 1,
            right: 1,
            child: InkWell(
              onTap: () {
                Provider.of<DisplayInfoModel>(context, listen: false)
                    .deleteDisplay(widget.rxID);
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
                Text(
                  widget.zoneName,
                  style: const TextStyle(color: Colors.black45, fontSize: 11),
                ),
                const SizedBox(height: 4),
                TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 2.0, top: 0.0, bottom: 0.0),
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintText: 'Display Name',
                        labelText: ''
                    ),
                    onChanged: (val) {
                      Provider.of<DisplayInfoModel>(context, listen: false)
                          .editDisplayName(widget.rxID, textController.text);
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
