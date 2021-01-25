import 'package:flutter/material.dart';
import 'package:genre_classification_app/screens/Test/testPage.dart';

class TestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TestPage()));
      },
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            child: Image.asset(
              "assets/images/test.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'TEST',
            style: Theme.of(context).textTheme.headline1,
          )
        ],
      ),
    );
  }
}
