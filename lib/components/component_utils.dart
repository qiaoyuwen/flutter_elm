import 'package:flutter/material.dart';

import '../routes/routes.dart';

class ComponentUtils {
  static Widget buildAppBar({
    BuildContext context,
    String title,
    bool centerTitle,
    Widget leading,
  }) {
    final ThemeData themeData = Theme.of(context);
    return new AppBar(
      leading: leading,
      title: new Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        new GestureDetector(
          onTap: () => _goLogin(context),
          child: new Container(
            padding: ButtonTheme.of(context).padding,
            child: new Center(
              child: new Text(
                '登录|注册',
                style: themeData.primaryTextTheme.title,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static _goLogin(BuildContext context) {
    Routes.router.navigateTo(context, '/login');
  }
}