import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
        _videoPlayerController = VideoPlayerController.file(File(_video.path))
          ..initialize().then((value) {
            setState(() {});
          });
      }
    } catch (e) {
      print("error: $e");
    }
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
                                onPressed: () {
                                  _videoPlayerController.value.isPlaying
                                      ? _videoPlayerController.play()
                                      : _videoPlayerController.pause();
                                },
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
                                  onPressed: () {},
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
