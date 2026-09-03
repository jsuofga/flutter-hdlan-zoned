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

  void _readIPAddress() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _ip_mdf = prefs.getString('ip_mdf') ?? '';
      textController_mdf.text = _ip_mdf;
    });
  }

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

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'IP Address of Cisco Network Switch',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: screenSize.width * 0.5,
              child: TextFormField(
                controller: textController_mdf,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter IP Address of MDF Switch',
                  labelText: _ip_mdf.isNotEmpty ? _ip_mdf : 'IP Address',
                ),
                onChanged: (val) {
                  setState(() {});
                },
                validator: (val) {
                  if (!RegExp(r"^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$")
                      .hasMatch(val!)) {
                    return 'Enter valid IP address of MDF Switch';
                  } else {
                    setState(() {
                      _ip_mdf = val;
                    });
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: screenSize.width * 0.5,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<UserInterfaceModel>(context, listen: false)
                              .hideIP();
                          Provider.of<SnmpModel>(context, listen: false).ipAddress =
                              _ip_mdf;
                          _saveIP();
                          _model = await Provider.of<SnmpModel>(context, listen: false)
                              .getModel(_ip_mdf);
                          _saveModel();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
