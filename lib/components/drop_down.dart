import 'dart:async';
import 'package:flutter/material.dart';
import '../style/style.dart';


const Duration _kDropDownSheetDuration = const Duration(milliseconds: 200);
typedef Offset _GetOffsetCall();

class DropDown extends StatefulWidget {
  DropDown({
    String text,
    Color color,
    Decoration decoration,
    _GetOffsetCall getOffset,
    Widget content,
  })  : text = text,
        color = color,
        decoration = decoration,
        getOffset = getOffset,
        content = content;
  final String text;
  final Color color;
  final Decoration decoration;
  final _GetOffsetCall getOffset;
  final Widget content;

  @override
  createState() => new DropDownState();

  static AnimationController createAnimationController(TickerProvider vsync) {
    return new AnimationController(
      duration: _kDropDownSheetDuration,
      debugLabel: 'DropDownSheet',
      vsync: vsync,
    );
  }
}

class DropDownState extends State<DropDown> {
  final _gPadding = new EdgeInsets.symmetric(vertical: 10.0);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        padding: _gPadding,
        color: widget.color,
        decoration: widget.decoration,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(widget.text),
            new Container(
              child: new Icon(
                Icons.arrow_drop_down,
                size: 20.0,
              ),
            )
          ],
        ),
      ),
      onTap: _show,
    );
  }

  void _show() {
    Offset offset = widget.getOffset();
    _showDropDownSheet(
      context: context,
      builder: (context) {
        return new Stack(
          children: <Widget>[
            new Positioned(
              top: offset.dy,
              right: 0.0,
              bottom: 0.0,
              left: offset.dx,
              child: new GestureDetector(
                child: new Container(
                  color: Colors.black54,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: new Container(
                padding: new EdgeInsets.only(top: offset.dy),
                child: widget.content,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DropDownSheetRoute<T> extends PopupRoute<T> {
  _DropDownSheetRoute({
    this.builder,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;

  @override
  Duration get transitionDuration => _kDropDownSheetDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => null;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = DropDown.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    var dropDownSheet = new Material(
      color: new Color.fromRGBO(0, 0, 0, 0.0),
      child: new MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: new _DropDownSheet<T>(route: this),
      )
    );
    return dropDownSheet;
  }
}

class _DropDownSheet<T> extends StatefulWidget {
  const _DropDownSheet({ Key key, this.route }) : super(key: key);

  final _DropDownSheetRoute<T> route;

  @override
  _DropDownSheetState<T> createState() => new _DropDownSheetState<T>();
}

class _DropDownSheetState<T> extends State<_DropDownSheet<T>> {
  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: widget.route.animation,
      builder: (BuildContext context, Widget child) {
        return new ClipRect(
          child: widget.route.builder(context),
        );
      }
    );
  }
}

Future<T> _showDropDownSheet<T>({
  BuildContext context,
  WidgetBuilder builder,
}) {
  assert(context != null);
  assert(builder != null);
  return Navigator.push(context, new _DropDownSheetRoute<T>(
    builder: builder,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  ));
}
