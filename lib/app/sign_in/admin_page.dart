import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/admin_page_form.dart';
import 'package:flutter_app/services/auth.dart';

class AdminLoginPage extends StatelessWidget {
  final AuthBase auth;

  AdminLoginPage({
    @required this.auth,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
          ),
        ),
        title: Text("Welcome, Admin"),
      ),
      body: Card(
        child: AdminPageForm(
          auth: auth,
        ),
      ),
    );
  }
}
