import 'package:flutter/material.dart';

class BigImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/images/big_1.png",
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
