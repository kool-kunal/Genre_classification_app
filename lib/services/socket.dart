import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class SocketUtil extends ChangeNotifier {
  String ip;
  int port;
  Socket _socket;
  List<String> label = ['action', 'drama', 'horror', 'romance'];
  bool sendingFile = false;
  bool waitingForResult = false;
  bool testingDone = false;
  int index = 0;
  List<Map<String, double>> output;
  double dataSent = 0.0;
  int payloadSize = 1000000;

  Future<void> _init({String ip, int port}) async {
    print("connecting to host $ip at $port");
    this.ip = ip;
    this.port = port;
    //this.messageStream = [];
    this._socket = await Socket.connect(this.ip, this.port);
  }

  void reset() {
    sendingFile = false;
    waitingForResult = false;
    testingDone = false;
    index = 0;
    dataSent = 0.0;
    notifyListeners();
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
        sendingFile = true;
        _send(utf8.encode(videoStream.length.toString()));
        notifyListeners();
      } else if (msg == "LENGTH RECEIVED") {
        print("length received");
        sendingFile = true;
        index = 0;
        _send(videoStream.sublist(
            index, min(videoStream.length, index + payloadSize)));
        index = min(videoStream.length, index + payloadSize);
        dataSent = index / videoStream.length;
        notifyListeners();
      } else if (sendingFile && msg == "BYTE RECEIVED") {
        //print(index);
        _send(videoStream.sublist(
            index, min(videoStream.length, index + payloadSize)));
        index = min(videoStream.length, index + payloadSize);
        if (index >= videoStream.length) {
          sendingFile = false;
          waitingForResult = true;
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
        List<String> temp = msg.split("=").last.split(" ");
        temp.removeLast();
        //print(temp);
        output = [];
        for (int i = 0; i < temp.length; i++) {
          String curr = double.parse(temp[i]).toStringAsFixed(4);
          output.add({this.label[i]: double.parse(curr) * 100});
        }
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
