import 'package:flutter/material.dart';
import 'package:hdlan_controller/screens/settings/synch_switch.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';

class AdminAccess extends StatefulWidget {
  const AdminAccess({Key? key}) : super(key: key);

  @override
  _AdminAccessState createState() => _AdminAccessState();
}

class _AdminAccessState extends State<AdminAccess> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ADMIN Password'),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,20.0),
              child: SizedBox(
                width:screenSize.width/2,
                child: TextFormField(
                    initialValue: '',
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                        ),
                        // icon:Icon(Icons.person),
                        hintText: 'Enter Admin Password',
                        labelText: ''
                    ),
                    onChanged: (val){

                    },
                    validator: (val) {
                      //Regular Expression check of IP address
                      if(val != 'octava+troipac'){
                        return 'Enter valid Admin Password';
                      }else{
                        setState(() {

                        });
                        return null;
                      }
                    }
                ),
              ),
            ),
            SizedBox(
              width:screenSize.width/2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      icon: Icon(Icons.close),
                      label: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        primary:Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                  ),
                  ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        primary:Colors.green,
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                           Provider.of<UserInterfaceModel>(context,listen: false).hideAdmin();
                          //Navigator.pop(context); // Closes the Bottom Modal
                        }else{
                           Provider.of<UserInterfaceModel>(context,listen: false).showAdmin();
                        }
                      }
                  ),
                ],
              ),
            ),

          ],
        ),
    );
  }
}
