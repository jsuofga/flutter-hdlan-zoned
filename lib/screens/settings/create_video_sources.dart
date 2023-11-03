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
  int  _txCount = 0;

  void showAlert() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning,color: Colors.amber,size: 50,),
            Text("Important"),
          ],
        ),
        content: Text("Max Number of VideoInputs is ${ _txCount}"),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(0,50.0,0,0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Add Video Inputs',style: TextStyle(fontSize: 30),),
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
                            hintText: 'Enter Video Source Name',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: ''
                        ),
                        onChanged: (val){
                          _videoSource= val;
                        },
                        validator: (val) {
                          //
                          if(val == ''){
                            return 'Enter Video Source ';
                          }else{
                            //Check if  Video Sources exceeds number of TX
                            if( Provider.of<SourceNamesModel>(context,listen:false).sourceInfoList.length < _txCount) {
                              Provider.of<SourceNamesModel>(context,listen:false).sourceInfoList.add(SourceInfo(sourceID: Provider.of<SourceNamesModel>(context,listen: false).sourceInfoList.length + 1, sourceName:  _videoSource));
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

            SingleChildScrollView(
              child: Container(
                  width: screenSize.width/2,
                  height: screenSize.height/2,
                  child:
                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                        children:Provider.of<SourceNamesModel>(context).sourceInfoList.map((item) => CardVideoSource(sourceID:item.sourceID,sourceName: item.sourceName)).toList(),

                  )

              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Save'),
              onPressed: (){
                Provider.of<SourceNamesModel>(context,listen: false).saveSourceNames();
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
