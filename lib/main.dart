import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:hdlan_controller/screens/settings/admin_access.dart';
import 'package:hdlan_controller/screens/settings/settings_menu.dart';
import 'package:hdlan_controller/screens/home.dart';
import 'package:hdlan_controller/screens/zones.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hdlan_controller/class_models.dart';

void main() {
  runApp(const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {



    return MultiProvider(
      providers: [
        // ChangeNotifierProvider( create: (context) => SwitchingModel()),
        ChangeNotifierProvider( create: (context) => UserInterfaceModel()),
        ChangeNotifierProvider( create: (context) => SnmpModel()),
        ChangeNotifierProvider( create: (context) => ZoneNamesModel()),
        ChangeNotifierProvider( create: (context) => DisplayInfoModel()),
        ChangeNotifierProvider( create: (context) => SourceNamesModel()),
        ChangeNotifierProvider( create: (context) => SwitchingModel())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

        ),
        home: const MyHomePage(title: 'Octava AVLAN Controller'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Provider.of<SnmpModel>(context,listen: false).startPoll();
    Provider.of<UserInterfaceModel>(context, listen: false).getZoneToShow();
  }

  // Bottom Sheet Modal - Admin and Settings
  void showSettingsPanel() {
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        minWidth: double.infinity,
      ),
      context: context,
      builder: (context) {
        final height100vh = MediaQuery.of(context).size.height;

        return Container(
          height: height100vh,
          width: double.infinity,
          color: Colors.white,
          child: Provider.of<UserInterfaceModel>(context).showAdminAccess ? const AdminAccess() : const SettingsMenu(),
        );
      },
    );
  }

//Defined variables

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;

    if (isTablet) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    // Banner - Show PoE banner, if poeWattage = 0
    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (Provider.of<SnmpModel>(context,listen: false).poeWattage == '0') {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text(
              '⚠️ Attention: PoE power consumption is 0 Watts',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green, // white background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () async {

                      ScaffoldMessenger.of(context).showSnackBar(
                        // Show a Snackbar
                          SnackBar(
                            content: Text('Wait... Powering on PoE',
                              textAlign: TextAlign.center, // Center the text
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.green, // Green background
                            duration: Duration(seconds: 10),
                            behavior: SnackBarBehavior.floating, // Optional: makes it float above bottom
                            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10), // Optional: padding
                          ),
                        );

                      // Close the Banner after 1 second
                      Future.delayed(Duration(seconds: 1), () {
                        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      });

                      // Turn PoE On
                          String ip = await Provider.of<SwitchingModel>(context, listen: false).getIPAddressMDFSwitch();
                          String tx_rx_total = (Provider.of<SnmpModel>(context, listen: false).txCount +
                              Provider.of<SnmpModel>(context, listen: false).rxCount).toString();
                          CiscoSmbSwitch(ipAddress: ip).poe_power({
                            'range': '1-${tx_rx_total}',
                            'powerInline_type': 'auto',
                          });
              },
                child: Text(
                  'Turn PoE ON',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      } else {
        // Hide it automatically once PoE power is restored
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });

    ///////////////////////////////////////////////////////////////////

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Image.asset("assets/octava-logo-white.png",height:20.0),
        centerTitle: true,
        backgroundColor: Color(0xFF2c3e50),
        actions: [
          Text('TullariHook|1.2'),
          TextButton.icon(
              onPressed: () {
                 Provider.of<UserInterfaceModel>(context,listen: false).showAdmin();
                 showSettingsPanel();
              },
              label: Text(''),
              icon: Icon(Icons.settings),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              )
          )
        ],
      ),

      backgroundColor: Color(0xFF000000),
      resizeToAvoidBottomInset: true,
      body: Provider.of<UserInterfaceModel>(context).showHome ? Home() : Zones(),

      bottomNavigationBar: Container(
        height: 60,
        color: Color(0xFF2c3e50),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // LEFT SIDE BUTTONS
            Positioned(
              left: 8,
              child: Row(
                children: [
                  /*
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red, width: 2), // green outline                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), // rounded corners
                      ),
                    ),
                    onPressed: () async {
                      String ip = await Provider.of<SwitchingModel>(context, listen: false).getIPAddressMDFSwitch();
                      String tx_rx_total = (Provider.of<SnmpModel>(context, listen: false).txCount +
                          Provider.of<SnmpModel>(context, listen: false).rxCount)
                          .toString();
                      CiscoSmbSwitch(ipAddress: ip).poe_power({
                        'range': '1-${tx_rx_total}',
                        'powerInline_type': 'never',
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        // Show a Snackbar
                        SnackBar(
                          content: Text('Powering OFF PoE',
                            textAlign: TextAlign.center, // Center the text
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.red, // Blue background
                          duration: Duration(seconds: 10),
                          behavior: SnackBarBehavior.floating, // Optional: makes it float above bottom
                          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10), // Optional: padding
                        ),
                      );
                    },
                    child: Text('PoE Off',
                      style: TextStyle(
                        color: Colors.red, // red text
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green, width: 2), // green outline
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // rounded corners
                        ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () async {
                      String ip = await Provider.of<SwitchingModel>(context, listen: false).getIPAddressMDFSwitch();
                      String tx_rx_total = (Provider.of<SnmpModel>(context, listen: false).txCount +
                          Provider.of<SnmpModel>(context, listen: false).rxCount)
                          .toString();
                      CiscoSmbSwitch(ipAddress: ip).poe_power({
                        'range': '1-${tx_rx_total}',
                        'powerInline_type': 'auto',
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        // Show a Snackbar
                        SnackBar(
                          content: Text('Wait... Powering ON PoE',
                            textAlign: TextAlign.center, // Center the text
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.green, // Blue background
                          duration: Duration(seconds: 10),
                          behavior: SnackBarBehavior.floating, // Optional: makes it float above bottom
                          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10), // Optional: padding
                        ),
                      );
                    },
                    child: Text('PoE On',
                      style: TextStyle(
                      color: Colors.green, //
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  */
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Power '+ Provider.of<SnmpModel>(context).poeWattage +' W' ,
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            // CENTER HOME BUTTON (Only shown if ALL Zones is selected in Settings, i.e. allowedZone == 0)
            Visibility(
              visible: Provider.of<UserInterfaceModel>(context).allowedZone == 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.workspaces_filled, size: 36, color: Colors.white),
                  onPressed: () {
                    Provider.of<UserInterfaceModel>(context, listen: false).showHomeScreen();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
              ),
            ),


          ],
        ),
      ),


    );
  }
}
