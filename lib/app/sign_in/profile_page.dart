import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/profile_page_form.dart';
import 'package:flutter_app/app/sign_in/subscriptions.dart';
import 'package:flutter_app/app/sign_in/view_profile.dart';
import 'package:flutter_app/services/auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 0;
  List<Widget> _children = [];

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
          'Profile',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
        ),
        elevation: 2.5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Card(child: ProfilePageForm()),
        ),
      ),
      backgroundColor: Colors.white12,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        items: [
          BottomNavyBarItem(
              inactiveColor: Colors.purple[900],
              activeColor: Colors.redAccent,
              icon: Icon(Icons.home),
              title: Text("Edit profile")),
          BottomNavyBarItem(
            inactiveColor: Colors.purple[900],
            icon: Icon(Icons.person_rounded),
            title: Text("View profile"),
          ),
          BottomNavyBarItem(
              inactiveColor: Colors.purple[900],
              activeColor: Colors.purple[900],
              icon: Icon(Icons.person),
              title: Text("Subscriptions"))
        ],
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                _currentIndex = 0;
                if (FirebaseAuth.instance.currentUser.email == null) {
                  print("error!");
                } else {
                  return ViewProfilePage();
                }
              }));
            } else if (_currentIndex == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                _currentIndex = 0;
                return Billing();
              }));
            }
          });
        },
      ),
    );
  }
}
