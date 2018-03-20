import 'package:flutter/material.dart';
import 'dart:async';
import '../style/style.dart';

class Carousel extends StatefulWidget {
  Carousel({
    double height = 200.0,
    List<Widget> pages,
    bool autoPlay,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 1000),
  })
    : height = height,
      pages = pages,
      autoPlay = autoPlay,
      duration = duration,
      animationDuration = animationDuration;

  final double height;
  final List<Widget> pages;
  final bool autoPlay;
  final Duration duration;
  final Duration animationDuration;

  @override
  createState() => new CarouselState();
}

class CarouselState extends State<Carousel> {
  final _pageController = new PageController();

  Timer _timer;
  int _currentPage = 0;
  bool reverse = false;
  GlobalKey<IndicatorState> _indicatorStateKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      _timer = new Timer.periodic(widget.duration, (timer) {
        _pageController.animateToPage(_currentPage,
            duration: widget.animationDuration, curve: Curves.linear);
        if (!reverse) {
          _currentPage += 1;
          if (_currentPage == widget.pages.length) {
            _currentPage -= 1;
            reverse = true;
          }
        } else {
          _currentPage -= 1;
          if (_currentPage < 0) {
            _currentPage += 1;
            reverse = false;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          height: widget.height,
          color: Style.backgroundColor,
          child: new PageView(
            controller: _pageController,
            children: widget.pages,
            onPageChanged: (index) {
              _currentPage = index;
              _indicatorStateKey.currentState.changeIndex(index);
            },
          ),
        ),
        new Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: new Align(
            child: new Indicator(
              key: _indicatorStateKey,
              count: widget.pages.length,
            ),
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}

class Indicator extends StatefulWidget {
  Indicator({Key key, int count})
      : count = count,
        super(key: key);

  final int count;

  @override
  createState() => new IndicatorState();
}

class IndicatorState extends State<Indicator> {
  int _index = 0;

  changeIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var indicators = <Widget>[];
    for (var i = 0; i < widget.count; ++i) {
      indicators.add(new Container(
        width: 5.0,
        height: 5.0,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          color: _index == i ? Style.primaryColor : Style.borderColor,
        ),
      ));
    }
    return new SizedBox(
      width: widget.count * 15.0,
      height: 30.0,
      child: new Row(
        children: indicators,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
