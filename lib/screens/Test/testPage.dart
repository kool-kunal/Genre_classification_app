import 'dart:io';

import 'package:flutter/material.dart';
import 'package:genre_classification_app/services/socket.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
              padding: const EdgeInsets.only(top: 30),
              alignment: Alignment.bottomCenter,
              height: 300,
              child: Image.asset("assets/images/test.png"),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
