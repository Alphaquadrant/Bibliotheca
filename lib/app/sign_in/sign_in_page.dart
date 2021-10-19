import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/admin_page.dart';
import 'package:flutter_app/app/sign_in/common_widgets/custom_raised_button.dart';
import 'package:flutter_app/app/sign_in/email_signin_page.dart';
import 'package:flutter_app/app/sign_in/sign_in_button.dart';
import 'package:flutter_app/app/sign_in/social_signIn_button.dart';
import 'package:flutter_app/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _googleSignIn() async {
    try {
      await auth.googleSignIn();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _facebookSignIn() async {
    try {
      await auth.facebookSignIn();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => EmailSignInPage(
              auth: auth,
            ),
        fullscreenDialog: true));
  }

  void _adminLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => AdminLoginPage(
                auth: auth,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
          ),
        ),
        title: Text(
          'Bibliotheca',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
        ),
        elevation: 2.5,
      ),
      body: Container(
        child: buildContainer(context),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/librarybackground.jpeg"),
                fit: BoxFit.fill)),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Sign-in here!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50.5,
          ),

          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            color: Colors.blueAccent,
            onPressed: () {
              _facebookSignIn();
            },
          ),
          // CustomRaisedButton(
          //
          //   child:Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //
          //     children: [
          //       Image.asset('images/google-logo.png'),
          //       Text("Sign in with Google",
          //         style: TextStyle(
          //           fontSize: 16,
          //         ),
          //
          //       ),
          //       Opacity(
          //           opacity: 0.0,
          //           child: Image.asset('images/google-logo.png')
          //       )
          //
          //
          //     ],
          //   ),
          //   color:Colors.white,
          //   onPressed: (){},
          //
          // ),

          SizedBox(
            height: 7.5,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with google',
            color: Colors.white70,
            onPressed: () {
              _googleSignIn();
            },
          ),
          SizedBox(
            height: 7.5,
          ),
          SignInButton(
            // assetName: 'images/maillogo.jpg',
            text: 'Sign in with email',
            color: Colors.teal[500],

            onPressed: () {
              _signInWithEmail(context);
            },
          ),
          SizedBox(height: 10.0),
          Text(
            'or',
            style: TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 7.5,
          ),
          SignInButton(
              text: 'Go anonymous',
              textColor: Colors.black,
              color: Colors.grey,
              onPressed: () {
                _signInAnonymously();
              }),
          SizedBox(
            height: 7.5,
          ),
          SignInButton(
              text: 'Admin Login',
              textColor: Colors.black,
              color: Colors.grey,
              onPressed: () {
                _adminLogin(context);
              }),
        ],
      ),
    );
  }
}
