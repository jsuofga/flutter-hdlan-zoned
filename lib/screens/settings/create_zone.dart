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
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning,color: Colors.amber,size: 50,),
            Text("Important"),
          ],
        ),
        content: Text("Max Number of Zones is 8"),
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

  @override
  void initState() {
    super.initState();
    Provider.of<ZoneNamesModel>(context,listen: false).getZoneInfo();
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    TextEditingController textController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0,20.0,0,0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              Text('Create Zones',style: TextStyle(fontSize: 30),),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
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
                                    iconSize: 50,
                                    onPressed: () {
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState!.validate()) {

                                      }else{

                                      }
                                    }
                                ),
                              ),
                              border: OutlineInputBorder(
                              ),
                              // icon:Icon(Icons.person),
                              hintText: 'Enter Name of Zone/Group',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: ''
                          ),
                          onChanged: (val){
                              _zoneName = val;
                          },
                          validator: (val) {
                            //
                            if(val == ''){
                              return 'Enter a Zone name';
                            }else{
                              //Check if  Zones exceeds 8
                               if( Provider.of<ZoneNamesModel>(context,listen:false).zoneInfoList.length <= 7) {
                                 Provider.of<ZoneNamesModel>(context,listen:false).zoneInfoList.add(ZoneInfo(zoneID: Provider.of<ZoneNamesModel>(context,listen: false).zoneInfoList.length + 1, zoneName: _zoneName));
                               }else{
                                 showAlert();
                               }
                              setState(() {
                                  textController.clear();
                              });
                              return null;
                            }
                          }
                      ),
                    ),

                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children:Provider.of<ZoneNamesModel>(context).zoneInfoList.map((item) => CardZone(zoneID:item.zoneID,zoneName: item.zoneName)).toList(),
                ),
              ),
              ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                onPressed: (){
                  Provider.of<ZoneNamesModel>(context,listen: false).saveZoneNames();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  // Navigator.pop(context);
                },
              ),

           ],

        ),
      ),
    );
  }
}



