import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdlan_controller/class_models.dart';
import 'package:hdlan_controller/custom/card_zone.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';

class CreateZone extends StatefulWidget {
  const CreateZone({Key? key}) : super(key: key);

  @override
  _CreateZoneState createState() => _CreateZoneState();
}

class _CreateZoneState extends State<CreateZone> {
  final _formKey = GlobalKey<FormState>();
  String _zoneName = '';

  void showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.amber, size: 50),
              Text("Important"),
            ],
          ),
          content: const Text("Max Number of Zones is 8"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok- Got it")),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ZoneNamesModel>(context, listen: false).getZoneInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    TextEditingController textController = TextEditingController();

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Provider.of<UserInterfaceModel>(context, listen: false).showHomeScreen();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                ),
                const Center(
                  child: Text(
                    'Create Zones',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Provider.of<ZoneNamesModel>(context, listen: false).saveZoneNames();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                      child: SizedBox(
                        width: screenSize.width > 600 ? screenSize.width / 2 : double.infinity,
                        child: TextFormField(
                          controller: textController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: Icon(Icons.add),
                              ),
                              iconSize: 30,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {}
                              },
                            ),
                            border: const OutlineInputBorder(),
                            hintText: 'Enter Name of Zone/Group',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: '',
                          ),
                          onChanged: (val) {
                            _zoneName = val;
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter a Zone name';
                            } else {
                              if (Provider.of<ZoneNamesModel>(context, listen: false)
                                      .zoneInfoList
                                      .length <=
                                  7) {
                                Provider.of<ZoneNamesModel>(context, listen: false)
                                    .zoneInfoList
                                    .add(ZoneInfo(
                                      zoneID: Provider.of<ZoneNamesModel>(context, listen: false)
                                              .zoneInfoList
                                              .length +
                                          1,
                                      zoneName: _zoneName,
                                    ));
                              } else {
                                showAlert();
                              }
                              setState(() {
                                textController.clear();
                              });
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                        ),
                        children: Provider.of<ZoneNamesModel>(context)
                            .zoneInfoList
                            .map((item) => CardZone(
                                  zoneID: item.zoneID,
                                  zoneName: item.zoneName,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
