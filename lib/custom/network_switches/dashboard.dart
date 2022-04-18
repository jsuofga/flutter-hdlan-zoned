import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          children: [
            Icon(Icons.inbox,
                color:Colors.orange
            ),
            Text('Transmitters = ${Provider.of<SnmpModel>(context).txCount}'),
          ],
        ),
        Row(
          children: [
            Icon(Icons.inbox,
                color:Colors.blue
            ),
            Text('Receivers = ${Provider.of<SnmpModel>(context).rxCount}'),
          ],
        ),
        Row(
          children: [
            Icon(Icons.inbox,
                color:Colors.black
            ),
            Text('Network = ${Provider.of<SnmpModel>(context).networkCount}'),
          ],
        )
      ],
    )
    ;
  }
}
