import 'package:flutter/material.dart';
//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:genre_classification_app/screens/home/homepage.dart';
import 'package:genre_classification_app/services/socket.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  @override
  Widget build(BuildContext context) {
    //FlutterStatusbarcolor.setStatusBarColor(Colors.lightBlueAccent);
    return ChangeNotifierProvider.value(
      value: SocketUtil(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.yellow[400],
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}
