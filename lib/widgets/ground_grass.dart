import 'package:flutter/material.dart';

class GroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.4)
      ..arcToPoint(
        Offset(size.width, size.height * 0.1),
        radius: Radius.circular(size.width),
      )
      ..lineTo(size.width, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Ground extends StatelessWidget {
  final double height;

  Ground(this.height);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: GroundClipper(),
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        color: Colors.green,
      ),
    );
  }
}
