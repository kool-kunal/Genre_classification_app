import 'dart:ffi';

import 'package:flutter/material.dart';

class AboutUsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          child: Image.asset(
            "assets/images/about_us.png",
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "ABOUT US",
          style: Theme.of(context).textTheme.headline1,
        )
      ],
    );
  }
}
