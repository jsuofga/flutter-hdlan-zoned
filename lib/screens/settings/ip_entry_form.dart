import 'package:flutter/material.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpEntryForm extends StatefulWidget {
  const IpEntryForm({Key? key}) : super(key: key);
  @override
  _IpEntryFormState createState() => _IpEntryFormState();
}

class _IpEntryFormState extends State<IpEntryForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController textController_mdf = TextEditingController();
  String _ip_mdf = ''; // MDF switch ip address
  String _model = '';

  @override
  void initState() {
    super.initState();
    _readIPAddress();
  }
  //Read from storage
  void _readIPAddress() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _ip_mdf = prefs.getString('ip_mdf') ?? '';
      textController_mdf.text = _ip_mdf;

    });
  }
  //Save to storage
   _saveIP() async {
     final prefs = await SharedPreferences.getInstance();
     await prefs.setString('ip_mdf', _ip_mdf);

  }
   _saveModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('model', _model);
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [

              Text('IP Address of Cisco Network Switch'),
              SizedBox(
                width: screenSize.width/3,
                child: TextFormField(
                  //initialValue:_ip_mdf ,
                    controller: textController_mdf,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                        ),
                        hintText: 'Enter IP Address of MDF Switch',
                        labelText: _ip_mdf
                    ),
                    onChanged: (val){
                      setState(() {

                      });
                    },
                    validator: (val) {
                      //Regular Expression check of IP address
                      if(!RegExp(r"^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$").hasMatch(val!) ){
                        return 'Enter IP address of MDF Switch';
                      }else{
                        setState(() {
                          _ip_mdf = val;
                        });
                        return null;
                      }
                    }
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle( fontSize: 20),
                        primary:Colors.green,
                      ),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.

                        if (_formKey.currentState!.validate()) {
                          Provider.of<UserInterfaceModel>(context,listen: false).hideIP();
                          Provider.of<SnmpModel>(context,listen: false).ipAddress = _ip_mdf;
                          // Save IP address to storage
                           _saveIP();
                           _model = await Provider.of<SnmpModel>(context,listen: false).getModel(_ip_mdf);
                           // Save model address to storage
                           _saveModel();
                         // Navigator.pop(context); // Closes the Bottom Modal
                        }
                      }
                  ),
                ),
              ),

            ],
          )
      ),
    );
  }
}
