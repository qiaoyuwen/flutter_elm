import 'package:flutter/material.dart';
import '../style/style.dart';
import '../components/form_input.dart';

class Login extends StatelessWidget {

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
                  ),
                  new FormInput(
                    type: FormInputType.password,
                    hintText: '密码',
                    onSaved: (val) => _password = val,
                    obscureText: true,
                  ),
                  new FormInput(
                    type: FormInputType.authCode,
                    hintText: '验证码',
                    onSaved: (val) => _authCode = val,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }
}