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
  int  _rxCount = 0;

  void showAlert(_input) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning,color: Colors.amber,size: 50,),
            Text("Important"),
          ],
        ),
        content: _input == 'no item selected'? Text("Assign a Zone from Drop Down Menu") : Text("Max Number of Displays is ${_rxCount}"),
        actions: [
          ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Ok- Got it")),
        ],
      );

    });
  }
  //Read from storage
  void _readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rxCount = prefs.getInt('rxCount') ?? 0;

    });
  }
  @override
  void initState() {
    super.initState();
    Provider.of<ZoneNamesModel>(context,listen: false).getZoneInfo();
    Provider.of<DisplayInfoModel>(context,listen: false).getDisplayInfo();
    _readFromStorage();
  }

  @override
  Widget build(BuildContext context) {

    List _menuItems = Provider.of<ZoneNamesModel>(context).zoneInfoList.map((item) => item.zoneName).toList();
    final Size screenSize = MediaQuery.of(context).size;
    TextEditingController textController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,0,0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,0,0),
            child: Text('Add Displays',style: TextStyle(fontSize: 30),),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width:screenSize.width/2,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              // child: Text("DropDownMENU"),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20,0,5,0),
                child: DropdownButton<String>(
                    isExpanded: true,
                    icon: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    hint: Center(
                      child: Text("Select Zone",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    value: _selectedItem == '' ? Provider.of<ZoneNamesModel>(context).zoneInfoList[0].zoneName : _selectedItem,
                    items: _menuItems
                        .map((item) => DropdownMenuItem<String>(
                      value:item,
                      child: Text(item),

                    )).toList(),
                    onChanged: (item) {
                      setState(() {
                        _selectedItem = item!;
                        _selectedItemIndex = _menuItems.indexOf(item);
                      });
                    }

                ),
              ),

            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0,.0,0.0,10.0),
              child: SizedBox(
                width:screenSize.width/2,
                child: TextFormField(
                  // initialValue: '',
                    controller: textController,
                    decoration: InputDecoration(
                        suffixIcon: Visibility(
                          child: IconButton(
                              icon: CircleAvatar(
                                child:Icon(Icons.add),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              iconSize: 30,
                              onPressed: () {
                                //Check if user selected a Drop Down Menu Item
                                if(_selectedItem == ''){
                                  showAlert('no item selected');
                                }else{
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {

                                  }else{}
                                }
                              }
                          ),
                        ),
                        border: OutlineInputBorder(
                        ),
                        // icon:Icon(Icons.person),
                        hintText: 'Enter Name of Display',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: ''
                    ),
                    onChanged: (val){
                      _displayName = val;
                    },
                    validator: (val) {
                      //
                      if(val == ''){
                        return 'Enter a display name';
                      }else{
                        //Check if  Display exceeds
                        if( Provider.of<DisplayInfoModel>(context,listen:false).displayInfoList.length <= _rxCount -1) {
                          Provider.of<DisplayInfoModel>(context,listen:false).displayInfoList.add(DisplayInfo(zoneID: _selectedItemIndex+1,rxID:Provider.of<DisplayInfoModel>(context,listen:false).displayInfoList.length +1 , zoneName:_selectedItem , displayName: _displayName));
                        }else{
                          showAlert('');
                        }
                        setState(() {
                          textController.clear();
                        });
                        return null;
                      }
                    }
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: screenSize.width/2,
              height: screenSize.height/2,
              child:
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                children:Provider.of<DisplayInfoModel>(context).displayInfoList.map((item) => CardDisplay(zoneID:item.zoneID,rxID:item.rxID,zoneName:item.zoneName,displayName: item.displayName)).toList(),

              )

               ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Save'),
              onPressed: (){
                Provider.of<DisplayInfoModel>(context,listen: false).saveDisplayInfo();
                Navigator.popUntil(context, ModalRoute.withName('/'));
                // Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}



