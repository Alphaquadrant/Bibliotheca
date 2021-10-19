import 'package:flutter/cupertino.dart';
import 'package:flutter_app/app/sign_in/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomRaisedButton{
  SignInButton({
    String text,
    Color color,
    Color textColor,
     VoidCallback onPressed(),

}): super(
    child: Text(text, style: TextStyle(color: textColor, fontSize: 16),
    ),
    color: color,
    onPressed: onPressed,
    borderRadius: 8.0,
    height: 40.0
  );
}