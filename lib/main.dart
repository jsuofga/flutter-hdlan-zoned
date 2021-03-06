import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:hdlan_controller/screens/settings/admin_access.dart';
import 'package:hdlan_controller/screens/settings/settings_menu.dart';
import 'package:hdlan_controller/screens/home.dart';
import 'package:hdlan_controller/screens/zones.dart';

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
        home: const MyHomePage(title: 'Octava HDLAN Controller'),
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
  }

  // Bottom Sheet Modal - Admin and Settings
  void showSettingsPanel() {
    showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 50),
          child: Provider.of<UserInterfaceModel>(context).showAdminAccess ? AdminAccess():SettingsMenu()
      );
    });
    // }).whenComplete(() => Provider.of<UserInterfaceModel>(context,listen: false).hideIP() );
  }

//Defined variables

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Image.asset("assets/octava-logo-white.png",height:20.0),
        centerTitle: true,
        backgroundColor: Color(0xFF2c3e50),
        actions: [
          Text('v4.18.22'),
          TextButton.icon(
              onPressed: () {
                 showSettingsPanel();
              },
              label: Text(''),
              icon: Icon(Icons.settings),
              style: TextButton.styleFrom(
                primary: Colors.white,
              )
          )
        ],
      ),

      backgroundColor: Color(0xFF000000),
      resizeToAvoidBottomInset: true,
      body: Provider.of<UserInterfaceModel>(context).showHome ? Home() : Zones(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: (){
          Provider.of<UserInterfaceModel>(context,listen: false).showHomeScreen();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.home),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
