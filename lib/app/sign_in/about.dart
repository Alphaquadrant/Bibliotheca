import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.teal, Colors.tealAccent, Colors.teal])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
              ),
            ),
            title: Text('About ')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset("images/liblogo.png"),
                /*Text(
                  'About Bibliothica',
                  style: GoogleFonts.anton(fontSize: 35),
                ),*/
                SizedBox(width: 40.0, height: 40.0),
                Text(
                    "\tHello and welcome 😄 \n \nWe're Yash and Vaishnav, passionate devs who absolutely ❤  building with Android and Flutter. \nWe build sleek solutions, bring product ideas to life and constantly strive to Research, Collaborate & Build.",
                    style: GoogleFonts.anton(fontSize: 20)),
                SizedBox(width: 40.0, height: 40.0),
                Image.asset("images/logo.png")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
