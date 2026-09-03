import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdlan_controller/class_models.dart';
import 'package:hdlan_controller/custom/card_video_source.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateVideoSources extends StatefulWidget {
  const CreateVideoSources({Key? key}) : super(key: key);

  @override
  _CreateVideoSourcesState createState() => _CreateVideoSourcesState();
}

class _CreateVideoSourcesState extends State<CreateVideoSources> {
  final _formKey = GlobalKey<FormState>();
  String _videoSource = '';
  int _txCount = 0;

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
          content: Text("Max Number of VideoInputs is ${_txCount}"),
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
                    'Add Video Inputs',
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
                      Provider.of<SourceNamesModel>(context, listen: false).saveSourceNames();
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
                            hintText: 'Enter Video Source Name',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: '',
                          ),
                          onChanged: (val) {
                            _videoSource = val;
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter Video Source ';
                            } else {
                              if (Provider.of<SourceNamesModel>(context, listen: false)
                                      .sourceInfoList
                                      .length <
                                  _txCount) {
                                Provider.of<SourceNamesModel>(context, listen: false)
                                    .sourceInfoList
                                    .add(SourceInfo(
                                      sourceID: Provider.of<SourceNamesModel>(context, listen: false)
                                              .sourceInfoList
                                              .length +
                                          1,
                                      sourceName: _videoSource,
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
                        children: Provider.of<SourceNamesModel>(context)
                            .sourceInfoList
                            .map((item) => CardVideoSource(
                                  sourceID: item.sourceID,
                                  sourceName: item.sourceName,
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
