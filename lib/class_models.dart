
import 'dart:io';
import 'dart:async';

class ZoneInfo{
  int zoneID;
  String zoneName;

  //Constructor
  ZoneInfo({required this.zoneID ,required this.zoneName });

  Map toJson() => {
    'zoneID': zoneID,
    'zoneName': zoneName,
  };

}
class SourceInfo{
  int sourceID;
  String sourceName;

  //Constructor
  SourceInfo({required this.sourceID ,required this.sourceName });

  Map toJson() => {
    'sourceID': sourceID,
    'sourceName': sourceName,
  };

}

class DisplayInfo{
  int zoneID;
  String zoneName;
  String displayName;
  int rxID;

  //Constructor
   DisplayInfo({required this.zoneID,required this.rxID,required this.zoneName,required this.displayName });
  // DisplayInfo({required this.zoneID,required this.zoneName,required this.displayName });

  Map toJson() => {
    'zoneID': zoneID,
    'rxID': rxID,
    'zoneName': zoneName,
    'displayName': displayName,
  };

}


// Cisco SMB Switch Telnet
class CiscoSmbSwitch{

  String ipAddress = '';
  // String username = '';
  // String password = '';
  int telnetPort = 23;

  // Constructor
  // CiscoSmbSwitch({this.ipAddress = '',this.username = '',this.password = ''});
  CiscoSmbSwitch({this.ipAddress = ''});

  //Methods
  void connect(Map payload) async {
    Socket socket = await Socket.connect(ipAddress, telnetPort);
    // socket.write('$username\r');
    socket.write('octava\r');
    sleep(new Duration(milliseconds: 200));
    // socket.write('$password\r');
    socket.write('sg300-octava\r');
    sleep(new Duration(milliseconds: 200));
    socket.write('config\r');
    sleep(new Duration(milliseconds: 200));
    socket.write('$payload\r');

    socket.write(payload['interfaceType'] + ' gi${payload['gi']} \r');
    sleep(new Duration(milliseconds: 200));
    socket.write('${payload['switchportType']}' + ' vlan${payload['vlan']} \r');
    sleep(new Duration(milliseconds: 200));
    socket.close();

  }

  void connectSwitchAllInZone(List payload, Map txCount_vlan) async {
    Socket socket = await Socket.connect(ipAddress, telnetPort);

    // socket.write('$username\r');
    socket.write('octava\r');
    sleep(new Duration(milliseconds: 200));
    // socket.write('$password\r');
    socket.write('sg300-octava\r');
    sleep(new Duration(milliseconds: 200));
    socket.write('config\r');
    sleep(new Duration(milliseconds: 200));

    for(int i = 0; i < payload.length;i++){
      print('interface gi${payload[i] + txCount_vlan['txCount']}\r');
      socket.write('interface gi${payload[i] + txCount_vlan['txCount']}\r');
      sleep(new Duration(milliseconds: 200));
      print('switchport access vlan ${txCount_vlan['vlan']}\r');
      socket.write('switchport access vlan ${txCount_vlan['vlan']}\r');
    }
    socket.close();
  }

}




