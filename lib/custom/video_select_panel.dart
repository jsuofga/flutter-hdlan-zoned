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
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final uiModel = Provider.of<UserInterfaceModel>(context, listen: false);
                    if (uiModel.showHome || uiModel.zoneToShow == 0) {
                      uiModel.showHomeScreen();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    } else {
                      uiModel.setZoneToShow(uiModel.zoneToShow);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              const Center(
                child: Text(
                  'Video Inputs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: Provider.of<SourceNamesModel>(context)
                      .sourceInfoList
                      .map((item) => VideoInputButton(
                          videoInputLabel: item.sourceName,
                          inputVlan: item.sourceID + 1))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
