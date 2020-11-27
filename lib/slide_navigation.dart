library slide_navigation;

import 'package:flutter/material.dart';

class OverlayNavigator extends StatefulWidget {
  final String title;
  final List<String> navTitle;
  final List<Widget> child;
  final Color navScreenColor;
  final Color navTextColor;
  final bool loading;

  OverlayNavigator(
      {Key key,
      this.title,
      this.navTitle,
      this.child,
      this.navScreenColor,
      this.navTextColor,
      this.loading = false,})
      : super(key: key);

  @override
  _OverlayNavigatorState createState() => _OverlayNavigatorState();
}

class _OverlayNavigatorState extends State<OverlayNavigator>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final double maxSlide = 150.0;
  int widgetIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.widgetIndex = 0;
    animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
  }

  void toggleAnimation() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.menu),
          onPressed: toggleAnimation,
        ),
      ),
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          double slide = maxSlide * animationController.value;
          double scale = 1 - (animationController.value * 0.3);
          return Stack(
            children: [
              Container(
                width: screenSize.width,
                height: screenSize.height,
                color: widget.navScreenColor,
              ),
              Container(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      color: widget.navTextColor,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: screenSize.width / 3,
                alignment: Alignment.center,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.navTitle.length,
                  padding: EdgeInsets.all(20.0),
                  itemBuilder: (context, index) {
                    return FlatButton(
                      child: Text(widget.navTitle[index]),
                      textColor: widget.navTextColor,
                      onPressed: () {
                        setState(() {
                          this.widgetIndex = index;
                        });
                        toggleAnimation();
                      },
                    );
                  },
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..scale(scale)
                  ..translate(slide),
                alignment: Alignment.centerRight,
                child: Container(
                    height: screenSize.height,
                    width: screenSize.width,
                    color: Colors.white,
                    child: widget.child[this.widgetIndex]),
              ),
            ],
          );
        },
      ),
    );
  }
}
