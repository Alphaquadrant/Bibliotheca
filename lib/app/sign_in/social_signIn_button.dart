import 'package:flutter/cupertino.dart';
import 'package:flutter_app/app/sign_in/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends CustomRaisedButton{
  SocialSignInButton({
     @ required String assetName,
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed(),

  }): super(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Image.asset(assetName),
          Text(text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
            ),

          ),
          Opacity(
              opacity: 0.0,
              child: Image.asset(assetName)
          )


        ],
      ),
      color: color,
      onPressed: onPressed,
      borderRadius: 15.0,
      height: 50.0
  );
}