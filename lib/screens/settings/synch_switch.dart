import 'package:flutter/material.dart';
import 'package:hdlan_controller/custom/network_switches/cbs250_350_24.dart';
import 'package:hdlan_controller/custom/network_switches/cbs250_350_48.dart';
import 'package:hdlan_controller/custom/network_switches/cbs250_350_16.dart';
import 'package:hdlan_controller/custom/network_switches/cbs250_350_8.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:hdlan_controller/screens/settings/ip_entry_form.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SynchSwitch extends StatefulWidget {
  const SynchSwitch({Key? key}) : super(key: key);

  @override
  _SynchSwitchState createState() => _SynchSwitchState();
}

class _SynchSwitchState extends State<SynchSwitch> {
  String model = '';
  List ports = [];
  bool showIPForm = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserInterfaceModel>(context, listen: false).showIP();
    });
  }

  @override
  Widget build(BuildContext context) {
    showNetworkSwitch() {
      RegExp re48port = RegExp(r'^(CBS[2,3]50-48|C1200-48|C1300-48)');
      RegExp re24port = RegExp(r'^(CBS[2,3]50-24|C1200-24|C1300-24)');
      RegExp re16port = RegExp(r'^(CBS[2,3]50-16|C1200-16|C1300-16)');
      RegExp re8port = RegExp(r'^(CBS[2,3]50-8|C1200-8|C1300-8)');

      if (re48port.hasMatch(Provider.of<SnmpModel>(context).model)) {
        return CBS_250_350_48port();
      } else if (re24port.hasMatch(Provider.of<SnmpModel>(context).model)) {
        return CBS_250_350_24port();
      } else if (re16port.hasMatch(Provider.of<SnmpModel>(context).model)) {
        return CBS_250_350_16port();
      } else if (re8port.hasMatch(Provider.of<SnmpModel>(context).model)) {
        return CBS_250_350_8port();
      } else {
        return const Center(child: Text('Switch Not Detected', style: TextStyle(color: Colors.black)));
      }
    }

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                visible: Provider.of<UserInterfaceModel>(context).showIPform,
                child: const IpEntryForm(),
              ),
              Visibility(
                visible: !Provider.of<UserInterfaceModel>(context).showIPform &&
                    !Provider.of<SnmpModel>(context).showSpinner,
                child: Text(
                  Provider.of<SnmpModel>(context).model,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              Visibility(
                visible: !Provider.of<UserInterfaceModel>(context).showIPform &&
                    !Provider.of<SnmpModel>(context).showSpinner,
                child: showNetworkSwitch(),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Visibility(
                  visible: Provider.of<SnmpModel>(context).showSpinner,
                  child: const SpinKitWave(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                ),
              ),
              Visibility(
                visible: Provider.of<SnmpModel>(context).showSpinner,
                child: Text(
                  'Scanning Network Switch | ${Provider.of<SnmpModel>(context).ipAddress}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              Visibility(
                visible: !Provider.of<UserInterfaceModel>(context).showIPform &&
                    Provider.of<SnmpModel>(context)
                        .model
                        .contains('No Compatible Network Switch Found') &&
                    !Provider.of<SnmpModel>(context).showSpinner,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<UserInterfaceModel>(context, listen: false)
                              .showIP();
                        },
                        label: const Text('Exit'),
                        icon: const Icon(Icons.exit_to_app),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !Provider.of<UserInterfaceModel>(context).showIPform &&
                        Provider.of<SnmpModel>(context).model !=
                            'No Compatible Network Switch Found' &&
                        !Provider.of<SnmpModel>(context).showSpinner,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: const Text('Cancel'),
                          icon: const Icon(Icons.error),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !Provider.of<UserInterfaceModel>(context).showIPform &&
                        Provider.of<SnmpModel>(context).model !=
                            'No Compatible Network Switch Found' &&
                        !Provider.of<SnmpModel>(context).showSpinner,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<UserInterfaceModel>(context, listen: false)
                                .showIP();
                            Provider.of<SnmpModel>(context, listen: false)
                                .saveTxRxCount();
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          },
                          label: const Text('Save'),
                          icon: const Icon(Icons.exit_to_app),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
