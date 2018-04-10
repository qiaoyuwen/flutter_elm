import 'package:flutter/material.dart';
import '../style/style.dart';
import '../utils/api.dart';
import 'dart:convert';
import 'dart:typed_data';

enum FormInputType {
  input,
  password,
  authCode,
}

class FormInput extends StatefulWidget {
  FormInput({
    FormInputType type = FormInputType.input,
    String hintText = '',
    FormFieldSetter<String> onSaved,
    bool obscureText = false,
    FormFieldValidator<String> validator,
  })
      : type = type,
        hintText = hintText,
        onSaved = onSaved,
        obscureText = obscureText,
        validator = validator;

  final FormInputType type;
  final String hintText;
  final FormFieldSetter<String> onSaved;
  final bool obscureText;
  final FormFieldValidator<String> validator;

  @override
  createState() => new FormInputState();
}

class FormInputState extends State<FormInput> {
  final _gPadding = new EdgeInsets.symmetric(horizontal: Style.gPadding, vertical: 15.0);

  bool _obscureText = false;
  Uint8List _authCodeImg;

  @override
  void initState() {
    super.initState();
    setState(() {
      _obscureText = widget.obscureText;
    });
    if (widget.type == FormInputType.authCode) {
      loadAuthCodeImg();
    }
  }

  void loadAuthCodeImg() {
    Api.getAuthCode().then((String code) {
      var splits = code.split(',');
      try {
        if (splits.length > 1 && mounted) {
          setState(() => _authCodeImg = BASE64.decode(splits[1]));
        }
      } catch (e) {
        print('decode base64 auth code img error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget suffixIcon;
    if (widget.type == FormInputType.password) {
      suffixIcon = new Switch(
        value: !_obscureText,
        onChanged: (val) {
          setState(() {
            _obscureText = !val;
          });
        },
      );
    } else if (widget.type == FormInputType.authCode) {
      var row = new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[],
      );
      if (_authCodeImg != null) {
        row.children.add(
          new Image.memory(_authCodeImg),
        );
      }
      row.children.add(
        new Padding(
          padding: new EdgeInsets.only(left: 10.0),
          child: new Column(
            children: <Widget>[
              new Text('看不清'),
              new GestureDetector(
                child: new Text(
                  '换一张',
                  style: new TextStyle(
                    color: Style.primaryColor,
                  ),
                ),
                onTap: loadAuthCodeImg,
              )
            ],
          ),
        ),
      );
      suffixIcon = row;
    }
    return new TextFormField(
      decoration: new InputDecoration(
        hintText: widget.hintText,
        suffixIcon: suffixIcon,
        contentPadding: _gPadding,
        hintStyle: Style.textStyle,
        border: new UnderlineInputBorder(
          borderSide: new BorderSide(
            color: Style.borderColor,
            width: 0.5,
          )
        )
      ),
      obscureText: _obscureText,
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }
}
