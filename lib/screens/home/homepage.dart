import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:genre_classification_app/widgets/about_usbutton.dart';
import 'package:genre_classification_app/widgets/big_image.dart';
import 'package:genre_classification_app/widgets/ground_grass.dart';
import 'package:genre_classification_app/widgets/testbutton.dart';
import 'package:genre_classification_app/widgets/uppercontainer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation _upperContainerBringInAnim,
      _groundBringInAnim,
      _bigImageBringInAnim,
      _testButtonBringInAnim,
      _aboutUsBringInAnim;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..addStatusListener((status) {
            print("animation completed");
          });

    _upperContainerBringInAnim = Tween<double>(begin: 0.0, end: 400.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _groundBringInAnim = Tween<double>(begin: 0.0, end: 300.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _bigImageBringInAnim = Tween<double>(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _testButtonBringInAnim = Tween<double>(begin: -130.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _aboutUsBringInAnim = Tween<double>(begin: 150.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, animation) => Container(
          color: Colors.white,
          child: Stack(
            children: [
              UpperContainer(_upperContainerBringInAnim.value),
              Positioned(
                bottom: 0,
                child: Ground(_groundBringInAnim.value),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                right: 5,
                child: Transform(
                    transform: Matrix4.translationValues(
                        _bigImageBringInAnim.value, 0, 0),
                    child: BigImage()),
              ),
              Positioned(
                left: 10,
                top: MediaQuery.of(context).size.height * 0.75,
                child: Transform(
                  transform: Matrix4.translationValues(
                      _testButtonBringInAnim.value, 0, 0),
                  child: Hero(
                    tag: "test",
                    child: TestButton(),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.4,
                bottom: 20,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0, _aboutUsBringInAnim.value, 0),
                    child: AboutUsButton()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
