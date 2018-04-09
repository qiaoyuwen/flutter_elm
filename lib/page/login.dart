import 'package:flutter/material.dart';
import '../style/style.dart';
import '../components/form_input.dart';
import '../components/button.dart';

class Login extends StatelessWidget {

  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding);
  final _gTopPadding = new EdgeInsets.only(top: 10.0);
  final _tipTextStyle = new TextStyle(
    color: Colors.red,
  );
  final formKey = new GlobalKey<FormState>();

  String _username;
  String _password;
  String _authCode;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        title: new Text('登录'),
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(top: 15.0),
            color: Style.backgroundColor,
            child: new Form(
              child: new Column(
                children: <Widget>[
                  new FormInput(
                    hintText: '账号',
                    onSaved: (val) => _username = val,
                    validator: (val) => val.length > 0 ? null : '请输入手机号/邮箱/用户名',
                  ),
                  new FormInput(
                    type: FormInputType.password,
                    hintText: '密码',
                    onSaved: (val) => _password = val,
                    obscureText: true,
                    validator: (val) => val.length > 0 ? null : '请输入密码',
                  ),
                  new FormInput(
                    type: FormInputType.authCode,
                    hintText: '验证码',
                    onSaved: (val) => _authCode = val,
                    validator: (val) => val.length > 0 ? null : '请输入验证码',
                  ),
                ],
              ),
            ),
          ),
          new Padding(
            padding: _gPadding,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: _gTopPadding,
                  child: new Text(
                    '温馨提示：未注册过的账号，登录时将自动注册',
                    style: _tipTextStyle,
                  ),
                ),
                new Padding(
                  padding: _gTopPadding,
                  child: new Text(
                    '注册过的用户可凭账号密码登录',
                    style: _tipTextStyle,
                  ),
                ),
                new Padding(
                  padding: _gTopPadding,
                  child: new Button(
                    height: 40.0,
                    text: '登录',
                    onTap: _login,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  void _login() {
  }
}