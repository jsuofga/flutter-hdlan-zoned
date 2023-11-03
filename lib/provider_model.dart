import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:dart_snmp/dart_snmp.dart';
import 'package:hdlan_controller/class_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create a ChangeNotifier Provider model:

class UserInterfaceModel extends ChangeNotifier {
  bool showAdminAccess = true;
  bool showSettingsMenu = false;
  bool showIPform = true;
  bool showHome = true;
  int zoneToShow = 0;

  //Methods
  setZoneToShow (_zone){
    showHome = false;
    zoneToShow = _zone;
    notifyListeners();
  }
  showHomeScreen() {
    showHome = true;
    notifyListeners();
  }
  showAdmin() {
    showAdminAccess = true;
    notifyListeners();
  }
  hideAdmin() {
    showAdminAccess = false;
    notifyListeners();
  }
  showSelectSettingsMenu() {
    showSettingsMenu = true;
    showAdminAccess = false;
    notifyListeners();
  }
  hideSelectSettingsMenu() {
    showSettingsMenu = false;
    showAdminAccess = true;
    notifyListeners();
  }
  showIP() {
    showIPform = true;
    notifyListeners();
  }
  hideIP() {
    showIPform = false;
    notifyListeners();
  }

}

class ZoneNamesModel extends ChangeNotifier{
  List zoneInfoList= [];

  saveZoneNames() async {
    // print(zoneInfoList);
    // Stringify zoneInfoList[] and save to storage
    String json_zoneInfoList= jsonEncode(zoneInfoList);//zoneInfoList [{zoneID: , zoneName:},...]
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('zoneInfo', json_zoneInfoList) ;
    //print('zoneinfo = ${jsonDecode(await prefs.getString("zoneInfo")!)}');
    notifyListeners();

  }
  getZoneInfo() async {
    zoneInfoList= [];
    final prefs = await SharedPreferences.getInstance();
    var data = await jsonDecode(await prefs.getString("zoneInfo")!);
    zoneInfoList = data.map((item) => ZoneInfo(zoneID: item['zoneID'], zoneName: item['zoneName'])).toList();
    // print(zoneInfoList);
    notifyListeners();
  }
  deleteZone(_zone) {
    //Delete zone
    zoneInfoList.removeAt(_zone-1);
    //Re assign zoneID so zoneID are sequential
    zoneInfoList.asMap().forEach((index, value) {
      zoneInfoList[index].zoneID = index + 1;
    });
     notifyListeners();
  }
  editZoneName(_zone,_zoneName){
    zoneInfoList[_zone-1].zoneName = _zoneName;
    notifyListeners();
  }

}
class SourceNamesModel extends ChangeNotifier{
  List sourceInfoList= [];

  saveSourceNames() async {
    // print(sourceInfoList);
    // Stringify zoneInfoList[] and save to storage
    String json_sourceInfoList= jsonEncode(sourceInfoList);//sourceInfoList [{sourceID: , sourceName:},...]
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sourceInfo', json_sourceInfoList) ;
    // print('sourceinfo = ${jsonDecode(await prefs.getString("sourceInfo")!)}');
    notifyListeners();

  }
  getSourceInfo() async {
    sourceInfoList= [];
    final prefs = await SharedPreferences.getInstance();
    var data = await jsonDecode(await prefs.getString("sourceInfo")!);
    sourceInfoList = data.map((item) => SourceInfo(sourceID: item['sourceID'], sourceName: item['sourceName'])).toList();
    // print(sourceInfoList);
    notifyListeners();
  }
  deleteSource(_source) {
    //Delete source
    sourceInfoList.removeAt(_source-1);
    //Re assign sourceID so sourceID are sequential
    sourceInfoList.asMap().forEach((index, value) {
      sourceInfoList[index].sourceID = index + 1;
    });
    notifyListeners();
  }
  editSourceName(_source,_sourceName){
    sourceInfoList[_source-1].sourceName = _sourceName;
    notifyListeners();
  }

}
class DisplayInfoModel extends ChangeNotifier{
  int zoneSelectedValue = 0;
  List displayInfoList= [];

  saveDisplayInfo() async {
    // print(displayInfoList);
    // Stringify zoneInfoList[] and save to storage
    String json_displayInfoList= jsonEncode(displayInfoList);//displayInfoList [{zoneID: , displayName:},...]
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayInfo', json_displayInfoList) ;
    // print('displayInfo= ${jsonDecode(await prefs.getString("displayInfo")!)}');
    notifyListeners();
  }

  getDisplayInfo() async{
    displayInfoList= [];
    final prefs = await SharedPreferences.getInstance();
    var data = await jsonDecode(await prefs.getString("displayInfo")!);
    displayInfoList = data.map((item) => DisplayInfo(zoneID: item['zoneID'],rxID:item['rxID'],zoneName: item['zoneName'],displayName: item['displayName'])).toList();
    // print(displayInfoList);
    notifyListeners();
  }
  deleteDisplay(_display) {
    //Delete zone
    displayInfoList.removeAt(_display-1);
    //Re assign display so displays are sequential
    displayInfoList.asMap().forEach((index, value) {
      displayInfoList[index].zoneID = index + 1;
    });
    notifyListeners();
  }
  editDisplayName(_display,_displayName){
    displayInfoList[_display-1].displayName = _displayName;
    notifyListeners();
  }

}

class SnmpModel extends ChangeNotifier {

  String model = '';
  String ipAddress = '';
  List vlanMembership = [];
  List portColors = [];
  List portStatus = [];
  bool showSpinner = false;
  int rxCount = 0;
  int txCount = 0;
  int networkCount = 0;

  startSpinner(){
    showSpinner = true;
  }
  stopSpinner(){
    showSpinner = false;
  }

  getModel(_ipAddress) async {

    startSpinner();

    Future.delayed(const Duration(seconds: 20), () {
      stopSpinner();
    });

    try{

      var target = InternetAddress(_ipAddress);
      var session = await Snmp.createSession(target);
      var oid = Oid.fromString('1.3.6.1.2.1.47.1.1.1.1.7.67109120'); // model
      var payload = await session.get(oid);
      var data = payload.pdu.varbinds[0].toString();
      //Removes everything after first ':'
      String result = data.substring(data.indexOf(':')+2);
      model = result;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('model', model);
      print('model is ${model}');
      notifyListeners();
      return result;

    }catch(e){
      model = 'No Compatible Network Switch Found';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('model', model);
      print(model);
      notifyListeners();
      return 'No Compatible Network Switch Found';
    }

  }
  startPoll(){
        Timer.periodic(Duration(seconds:5), (timer) async {
            await pollVlanMembership();
        });

  }
  pollVlanMembership() async{

    try{
      // Read from storage
       final prefs = await SharedPreferences.getInstance();
       ipAddress = await prefs.getString('ip_mdf') ?? '';
       model = await prefs.getString('model') ?? '';

      var target = InternetAddress(ipAddress);
      var session = await Snmp.createSession(target);

      vlanMembership = [];  //
      portColors = [];
      portStatus = [];

      RegExp re = RegExp(r'^CBS[2,3]50');
      int ports = 1;
      if (re.hasMatch(model)){
        if(model.contains('48')){
          ports = 52;
        }else if(model.contains('24')){
           ports = 28;
         // ports = 24; //Temp for CBS250-24T
        }else if (model.contains('16')){
          ports = 18;
        }else{}
      }
      // SNMP - get port vlan membership
      for(var i = 1;i<= ports; i++){
        var oid = Oid.fromString('1.0.8802.1.1.2.1.5.32962.1.2.1.1.1.${i}' ); // vlan membership
        var payload = await session.get(oid);
        var data = payload.pdu.varbinds[0].toString();

        String result = data.substring(data.indexOf(':')+2);  //Removes everything after first ':'
        vlanMembership.add(result);

        // Assign Port Colors
        if(result == '1'){
          portColors.add(Colors.black);
        } else if(result == '2'){
          i ==1 ? portColors.add(Colors.orange):portColors.add(Colors.blue);
        } else {
          portColors.add(Colors.orange);
        }
      }

       // SNMP - get port status
       for(var i = 1;i<= ports; i++){
         var oid_port_status = Oid.fromString('1.3.6.1.2.1.2.2.1.8.${i}'); // port status
         var payload = await session.get(oid_port_status);
         var data = payload.pdu.varbinds[0].toString();
         String result = data.substring(data.indexOf(':')+2);  //Removes everything after first ':'
         portStatus.add(int.parse(result));
        // print('portStatus = ${portStatus}');
       }
       //  Determine TX and RX Count

       networkCount = vlanMembership.where( (vlan) => (vlan == '1')).length;
       rxCount = (vlanMembership.where( (vlan) => (vlan == '2')).length - 1);
       txCount = vlanMembership.length - networkCount - rxCount ;


      notifyListeners();
      return ;

    }
    catch(e){
      model = 'No Compatible Network Switch Found';
      // print('inside Catch');
      notifyListeners();
      return ;
    }

  }

  saveTxRxCount() async {
    // print('Saving');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rxCount', rxCount);
    await prefs.setInt('txCount', txCount);
  }

}
class SwitchingModel extends ChangeNotifier {

  String switchUnit = '';
  String port = '';
  int vlan = 0;
  String MDF_IP = '';
  String IDF_IP = '';
  String username = '';
  String password = '';
  int zoneSelect = 0;

  //Methods
  //Read from storage
  getIPAddressMDFSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    //Read from storage
    MDF_IP = prefs.getString('ip_mdf') ?? '';
    // print('mdf is $MDF_IP');
    notifyListeners();
    return MDF_IP;
  }
  getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    //Read from storage
    username = prefs.getString('username') ?? '';
    // print('username is $username');
    notifyListeners();
    return username;
  }
  getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    //Read from storage
    password = prefs.getString('password') ?? '';
    // print('password is $password');
    notifyListeners();
    return password;
  }
  selectPort(_port){
    port = _port;
    // print('port:${port}');
    zoneSelect = 0;
    notifyListeners();
  }
  selectInput(_inputVlan){
    vlan = _inputVlan;
    // print('vlan:${vlan}');
    notifyListeners();
  }

  selectZone(_zoneSelect){
    zoneSelect = _zoneSelect;
    // print('selectZone:${zoneSelect}');
    notifyListeners();
  }

}





