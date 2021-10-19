import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/home_page.dart';
import 'package:flutter_app/services/auth.dart';

import 'admin_panel.dart';
class AdminPageForm extends StatefulWidget {
  AdminPageForm({
    @required this.auth,
  });

  final AuthBase auth;
  @override
  _AdminPageFormState createState() => _AdminPageFormState();
}

class _AdminPageFormState extends State<AdminPageForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  List <Widget> _buildChildren(){
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 30.0,
        width: 30.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 30.0,
        width: 30.0,
      ),
      ElevatedButton(
        onPressed: () {
          if(_email == "admin123@gmail.com" && _password == "admin123"){
            print("logged in!");
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return Librarian();
            } ));
          }
          else{
            print("failed");
          }
          _emailController.clear();
          _passwordController.clear();

        },
        child: Text("submit")

      ),

    ];
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: _buildChildren(),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Test@test.com",
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "password",
      ),
      textInputAction: TextInputAction.done,
      obscureText: true,
    );
  }


}

