import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdlan_controller/class_models.dart';
import 'package:hdlan_controller/custom/card_displays.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateDisplays extends StatefulWidget {
  const CreateDisplays({Key? key}) : super(key: key);

  @override
  _CreateDisplaysState createState() => _CreateDisplaysState();
}

class _CreateDisplaysState extends State<CreateDisplays> {
  final _formKey = GlobalKey<FormState>();
  String _displayName = '';
  String _selectedItem = '';
  int _selectedItemIndex = 0;
  int _rxCount = 0;

  void showAlert(_input) {
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
          content: _input == 'no item selected'
              ? const Text("Assign a Zone from Drop Down Menu")
              : Text("Max Number of Displays is ${_rxCount}"),
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
      _rxCount = prefs.getInt('rxCount') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ZoneNamesModel>(context, listen: false).getZoneInfo();
    Provider.of<DisplayInfoModel>(context, listen: false).getDisplayInfo();
    _readFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    List _menuItems = Provider.of<ZoneNamesModel>(context)
        .zoneInfoList
        .map((item) => item.zoneName)
        .toList();
    final Size screenSize = MediaQuery.of(context).size;
    TextEditingController textController = TextEditingController();

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16.0),
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
                  'Add Displays',
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
                    Provider.of<DisplayInfoModel>(context, listen: false).saveDisplayInfo();
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
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: screenSize.width > 600 ? screenSize.width / 2 : double.infinity,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          icon: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.arrow_drop_down_sharp,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                          hint: const Center(
                            child: Text(
                              "Select Zone",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          value: _selectedItem == ''
                              ? (Provider.of<ZoneNamesModel>(context).zoneInfoList.isNotEmpty
                                  ? Provider.of<ZoneNamesModel>(context).zoneInfoList[0].zoneName
                                  : null)
                              : _selectedItem,
                          items: _menuItems
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (item) {
                            setState(() {
                              _selectedItem = item!;
                              _selectedItemIndex = _menuItems.indexOf(item);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: SizedBox(
                      width: screenSize.width > 600 ? screenSize.width / 2 : double.infinity,
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          suffixIcon: Visibility(
                            child: IconButton(
                              icon: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: Icon(Icons.add),
                              ),
                              iconSize: 30,
                              onPressed: () {
                                if (_selectedItem == '') {
                                  showAlert('no item selected');
                                } else {
                                  if (_formKey.currentState!.validate()) {}
                                }
                              },
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          hintText: 'Enter Name of Display',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: '',
                        ),
                        onChanged: (val) {
                          _displayName = val;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter a display name';
                          } else {
                            if (Provider.of<DisplayInfoModel>(context, listen: false)
                                    .displayInfoList
                                    .length <=
                                _rxCount - 1) {
                              Provider.of<DisplayInfoModel>(context, listen: false)
                                  .displayInfoList
                                  .add(DisplayInfo(
                                    zoneID: _selectedItemIndex + 1,
                                    rxID: Provider.of<DisplayInfoModel>(context, listen: false)
                                            .displayInfoList
                                            .length +
                                        1,
                                    zoneName: _selectedItem,
                                    displayName: _displayName,
                                  ));
                            } else {
                              showAlert('');
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
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                      ),
                      children: Provider.of<DisplayInfoModel>(context)
                          .displayInfoList
                          .map((item) => CardDisplay(
                                zoneID: item.zoneID,
                                rxID: item.rxID,
                                zoneName: item.zoneName,
                                displayName: item.displayName,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
