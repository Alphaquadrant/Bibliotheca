import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth.dart';

import 'email_signin_form.dart';

class EmailSignInPage extends StatelessWidget {
  final AuthBase auth;

  EmailSignInPage({
    @required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign-In',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
        ),
        elevation: 2.5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Card(
              child: EmailSignInForm(
            auth: auth,
          )),
        ),
      ),
      backgroundColor: Colors.white12,
    );
  }

// Widget buildContainer() {
//   return Container();
// }

}
