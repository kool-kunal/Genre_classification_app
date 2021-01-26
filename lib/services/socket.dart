import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class SocketUtil extends ChangeNotifier {
  String ip;
  int port;
  Socket _socket;
  List<String> messageStream;
  bool sendingFile = false;
  bool waitingForResult = false;
  bool testingDone = false;
  int index = 0;
  String output = "";
  double dataSent = 0.0;

  Future<void> _init({String ip, int port}) async {
    print("connecting to host $ip at $port");
    this.ip = ip;
    this.port = port;
    this.messageStream = [];
    this._socket = await Socket.connect(this.ip, this.port);
  }

  Future<void> _close() async {
    print("closing connection");
    await this._socket.close();
    this._socket.destroy();
  }

  Future<void> _send(data) async {
    this._socket.add(data);
  }

  void checkFile({
    String ip,
    int port,
    File videoFile,
  }) async {
    //connect to server
    await _init(ip: ip, port: port);

    Uint8List videoStream = await videoFile.readAsBytes();
    _send(utf8.encode("START"));

    this._socket.listen((event) {
      String msg = utf8.decode(event);
      if (msg == "START") {
        _send(utf8.encode(videoStream.length.toString()));
      } else if (msg == "LENGTH RECEIVED") {
        print("length received");
        sendingFile = true;
        index = 0;
        _send(
            videoStream.sublist(index, min(videoStream.length, index + 1000)));
        index = min(videoStream.length, index + 1000);
        dataSent = index / videoStream.length;
        notifyListeners();
      } else if (sendingFile && msg == "BYTE RECEIVED") {
        print(index);
        _send(
            videoStream.sublist(index, min(videoStream.length, index + 1000)));
        index = min(videoStream.length, index + 1000);
        if (index >= videoStream.length) {
          sendingFile = false;
        }
        dataSent = index / videoStream.length;
        notifyListeners();
      } else if (msg == "FILE RECEIVED") {
        print("file sent successful!");
        _send(utf8.encode("BEGIN TEST"));
      } else if (msg == "RUNNING TEST") {
        waitingForResult = true;
        notifyListeners();
        print("running test");
      } else if (msg == "SENDING RESULT") {
        _send(utf8.encode("SEND RESULT"));
      } else if (msg.contains("FINAL_RESULT")) {
        output = msg.split("=").last;
        print(output);
        _send(utf8.encode("CLOSE"));
        _close();
        waitingForResult = false;
        testingDone = true;
        notifyListeners();
      }
    });

    //close the connection and destroy server
  }
}
