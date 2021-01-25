import 'package:flutter/material.dart';

class UpperContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height * 0.7)
      ..arcToPoint(Offset(size.width * 0.2, size.height * 0.95),
          radius: Radius.circular(size.width * 0.15), clockwise: false)
      ..lineTo(size.width * 0.9, size.height * 0.6)
      ..arcToPoint(Offset(size.width, size.height * 0.6 - size.width * 0.1),
          radius: Radius.circular(size.width * 0.4), clockwise: false)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class UpperContainer extends StatefulWidget {
  final double height;
  UpperContainer(this.height);
  @override
  _UpperContainerState createState() => _UpperContainerState();
}

class _UpperContainerState extends State<UpperContainer> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: UpperContainerClipper(),
      child: Container(
        height: widget.height,
        width: screenWidth,
        color: Colors.lightBlueAccent,
      ),
    );
  }
}
