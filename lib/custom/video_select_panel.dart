import 'package:flutter/material.dart';
import 'package:hdlan_controller/custom/button_video_input.dart';
import 'package:provider/provider.dart';
import 'package:hdlan_controller/provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoSelectPanel extends StatefulWidget {
  const VideoSelectPanel({Key? key}) : super(key: key);

  @override
  _VideoSelectPanelState createState() => _VideoSelectPanelState();
}

class _VideoSelectPanelState extends State<VideoSelectPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Text('Video Inputs',style: TextStyle(fontSize: 30),),
                    Wrap(
                      children: Provider.of<SourceNamesModel>(context).sourceInfoList.map((item) => VideoInputButton(videoInputLabel: item.sourceName, inputVlan: item.sourceID+1)).toList(),
                    )


                  ],
      ),

    );
  }
}
