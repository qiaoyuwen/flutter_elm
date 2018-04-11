import 'package:flutter/material.dart';
import '../style/style.dart';
import '../components/form_input.dart';
import '../components/button.dart';
import '../utils/api.dart';
import '../utils/ui_utils.dart';
import '../model/user.dart';
import '../utils/local_storage.dart';
import '../components/head_bar.dart';

class Login extends StatefulWidget {
  @override
  createState() => new LoginState();
}

class LoginState extends State<Login> {
  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding);
  final _gTopPadding = new EdgeInsets.only(top: 10.0);
  final _tipTextStyle = new TextStyle(
    color: Colors.red,
  );
  final formKey = new GlobalKey<FormState>();
  final authCodeInputKey = new GlobalKey<FormInputState>();

  String _username;
  String _password;
  String _authCode;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: '登录',
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(top: 15.0),
            color: Style.backgroundColor,
            child: new Form(
              key: formKey,
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
                    key: authCodeInputKey,
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
                new Padding(
                  padding: _gTopPadding,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new GestureDetector(
                        child: new Text(
                          '重置密码？',
                          style: new TextStyle(
                            color: Style.primaryColor,
                          ),
                        ),
                      ),
                    ],
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

  _login() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      var data = await Api.accountLogin(_username, _password, _authCode);
      if (data != null) {
        if (data['user_id'] != null) {
          try {
            var user = new User.fromJson(data);
            await LocalStorage.setUser(user);
            Navigator.of(context).pop();
          } catch(e) {
            showDialog(
              context: context,
              child: UiUtils.getSimpleAlert('错误', '$e'),
            );
          }
        } else {
          showDialog(
            context: context,
            child: UiUtils.getSimpleAlert('提示', data['message']),
          );
          _loadAuthCode();
        }
      }
    }
  }

  _loadAuthCode() {
    authCodeInputKey.currentState.loadAuthCodeImg();
  }
}