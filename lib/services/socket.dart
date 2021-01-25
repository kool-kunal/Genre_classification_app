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
    bool _sendingFile = false;
    int index = 0;
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
        _sendingFile = true;
        index = 0;
        _send(
            videoStream.sublist(index, min(videoStream.length, index + 1000)));
        index += 1000;
      } else if (_sendingFile && msg == "BYTE RECEIVED") {
        //print(index);
        _send(
            videoStream.sublist(index, min(videoStream.length, index + 1000)));
        index += 1000;
        if (index >= videoStream.length) {
          _sendingFile = false;
        }
      } else if (msg == "FILE RECEIVED") {
        print("file sent successful!");
      }
    });

    //close the connection and destroy server
  }
}
