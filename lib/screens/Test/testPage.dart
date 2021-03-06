import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:genre_classification_app/services/socket.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:video_player/video_player.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  PickedFile _video;
  double _cardHeight = 200;
  double _cardWidth = 300;
  VideoPlayerController _videoPlayerController;
  double progressBarHeight = 0;
  double backgroundProgressBarWidth = 0;
  double frontProgressBarWidth = 0;

  void _pickVideo() async {
    try {
      PickedFile p = await ImagePicker().getVideo(source: ImageSource.gallery);
      if (p != null) {
        _video = p;

        // _videoPlayerController = VideoPlayerController.network(
        //     "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        //   ..initialize().then((value) {
        //     setState(() {});
        //   });

        _videoPlayerController = VideoPlayerController.file(File(_video.path))
          ..initialize().then((value) {
            _videoPlayerController.setLooping(true);
            _videoPlayerController.play();
            setState(() {});
            Provider.of<SocketUtil>(context, listen: false).reset();
          });
      }
    } catch (e) {
      print("error: $e");
    }
  }

  void _play() {
    _videoPlayerController.play();
    setState(() {});
  }

  void _pause() {
    _videoPlayerController.pause();
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cardHeight = MediaQuery.of(context).size.height * 0.4;
    _cardWidth = MediaQuery.of(context).size.width * 0.8;
    var comm = Provider.of<SocketUtil>(context);
    if (comm.sendingFile && !comm.waitingForResult && !comm.testingDone)
      setState(() {
        //print("sending is true");
        _cardHeight = MediaQuery.of(context).size.height * 0.4 + 12;
      });
    else if (!comm.sendingFile && !comm.waitingForResult && comm.testingDone) {
      _cardHeight = MediaQuery.of(context).size.height * 0.5;
    } else
      setState(() {
        _cardHeight = MediaQuery.of(context).size.height * 0.4;
      });

    if (comm.sendingFile && !comm.waitingForResult && !comm.testingDone) {
      setState(() {
        progressBarHeight = 10;
        frontProgressBarWidth =
            MediaQuery.of(context).size.width * 0.6 * comm.dataSent;
        backgroundProgressBarWidth = MediaQuery.of(context).size.width * 0.6;
      });
    } else {
      setState(() {
        progressBarHeight = 0;
        frontProgressBarWidth = 0;
        backgroundProgressBarWidth = 0;
      });
    }
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            color: Colors.lightBlueAccent,
          ),
          //TestPageBackground(height, factor)
          Hero(
            tag: "test",
            child: Container(
              padding: const EdgeInsets.all(30),
              alignment: Alignment.bottomRight,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset("assets/images/test.png"),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topCenter,
              child: _video == null
                  ? RaisedButton(
                      onPressed: _pickVideo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Pick a video",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    )
                  : Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.white,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(20),
                        height: _cardHeight,
                        width: _cardWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_videoPlayerController != null &&
                                _videoPlayerController.value.initialized)
                              Flexible(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: AspectRatio(
                                      aspectRatio: _videoPlayerController
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(_videoPlayerController)),
                                ),
                              ),
                            if (_videoPlayerController != null &&
                                _videoPlayerController.value.initialized)
                              RaisedButton(
                                onPressed:
                                    _videoPlayerController.value.isPlaying
                                        ? _pause
                                        : _play,
                                shape: CircleBorder(),
                                color: Colors.amber,
                                child: _videoPlayerController.value.isPlaying
                                    ? Icon(
                                        Icons.pause,
                                        color: Colors.blueGrey,
                                      )
                                    : Icon(
                                        Icons.play_arrow,
                                        color: Colors.blueGrey,
                                      ),
                              ),
                            Stack(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: progressBarHeight,
                                  width: backgroundProgressBarWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: progressBarHeight,
                                  width: frontProgressBarWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.lightBlue,
                                  ),
                                )
                              ],
                            ),
                            if (!comm.sendingFile &&
                                !comm.waitingForResult &&
                                comm.testingDone)
                              Flexible(
                                child: SfCircularChart(
                                  legend: Legend(
                                    isVisible: true,
                                    title: LegendTitle(
                                      text: "Genre",
                                      textStyle: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    position: LegendPosition.left,
                                  ),
                                  series: <CircularSeries>[
                                    DoughnutSeries(
                                      dataSource: comm.output,
                                      xValueMapper: (data, _) =>
                                          data.keys.toList()[0],
                                      yValueMapper: (data, _) =>
                                          data.values.toList()[0],
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true),
                                    )
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if ((!comm.sendingFile &&
                                        !comm.testingDone &&
                                        !comm.waitingForResult) ||
                                    (!comm.sendingFile &&
                                        !comm.waitingForResult &&
                                        comm.testingDone))
                                  RaisedButton(
                                    onPressed: _pickVideo,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    color: Colors.amber,
                                    child: Text(
                                      "Pick another Video",
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                  ),
                                if (comm.sendingFile == false &&
                                    comm.testingDone == false &&
                                    comm.waitingForResult == false)
                                  RaisedButton(
                                    onPressed: () {
                                      Provider.of<SocketUtil>(context,
                                              listen: false)
                                          .checkFile(
                                        ip: "192.168.43.175",
                                        port: 5050,
                                        videoFile: File(_video.path),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    color: Colors.amber,
                                    child: Text(
                                      "Upload File",
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
