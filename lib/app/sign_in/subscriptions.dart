import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/profile_page.dart';
import 'package:flutter_app/app/sign_in/view_profile.dart';
import 'package:google_fonts/google_fonts.dart';

class Billing extends StatefulWidget {
  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Query subReference = FirebaseFirestore.instance
      .collection('Users')
      .firestore
      .collectionGroup('Subscriptions');

  int _currentIndex = 2;
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
        title: Text("Billing and fines "),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        items: [
          BottomNavyBarItem(
              inactiveColor: Colors.purple[900],
              icon: Icon(Icons.home),
              title: Text("Edit profile")),
          BottomNavyBarItem(
            activeColor: Colors.purple[900],
            icon: Icon(Icons.person_rounded),
            title: Text("View profile"),
          ),
          BottomNavyBarItem(
              activeColor: Colors.redAccent,
              inactiveColor: Colors.purple[900],
              icon: Icon(Icons.person),
              title: Text("Bills/Fines"))
        ],
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              _currentIndex = 1;
              Navigator.pop(context);
              return ProfilePage();

              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //
              //   return ProfilePage();
              //
              // })
              // );
            } else {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ViewProfilePage();
              }));
            }
          });
        },
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(-1.0, -4.0),
                end: Alignment(1.0, 4.0),
                colors: [Colors.red, Colors.redAccent, Colors.red])),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid)
                  .collection('Subscriptions')
                  .snapshots(),
              builder:
                  (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Text("Wait");

                  default:
                    if (snapshot.data.docs.isNotEmpty) {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            String bookName =
                                snapshot.data.docs[index]['book_name'];
                            DateTime rentedAt = (snapshot.data.docs[index]
                                    ['Rented_at'])
                                .toDate();
                            DateTime returnDate = (snapshot.data.docs[index]
                                    ['Return_deadline'])
                                .toDate();
                            DateTime currentDate = DateTime.now();
                            int difference =
                                currentDate.difference(returnDate).inDays + 1;
                            int fineIncurred = difference * 20;
                            if (currentDate.isAfter(returnDate)) {
                              return Card(
                                  child: Column(children: [
                                Text(
                                  " Fined for : ${bookName} \n Late by ${difference} days\n"
                                  " fine incurred = ${fineIncurred}Rs \n ",
                                  style: GoogleFonts.cabin(fontSize: 20),
                                ),
                                Text("Rented this book on ${rentedAt}"),
                                SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                ),
                              ]));
                            } else {
                              return Center(child: Text(""));
                            }
                            return Column(children: [
                              Center(
                                  child: Text(
                                      'Books : ${bookName}\n Rented at: ${rentedAt}\n Retrun date is ${returnDate}\n')),
                            ]);
                          });
                    } else {
                      Text("Failed! Some error has occured...");
                    }
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }
}
