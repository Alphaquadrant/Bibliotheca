import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/profile_page.dart';
import 'package:flutter_app/app/sign_in/subscriptions.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final deleteRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collection =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference subCollection = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('Subscriptions');

  final userID = FirebaseAuth.instance.currentUser.uid;

  int _currentIndex = 1;

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
          title: Text("Your profile"),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          items: [
            BottomNavyBarItem(
                inactiveColor: Colors.purple[900],
                icon: Icon(Icons.home),
                title: Text("Edit profile")),
            BottomNavyBarItem(
              activeColor: Colors.redAccent,
              icon: Icon(Icons.person_rounded),
              title: Text("View profile"),
            ),
            BottomNavyBarItem(
                inactiveColor: Colors.purple[900],
                icon: Icon(Icons.person),
                title: Text("Subscriptions"))
          ],
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 0) {
                Navigator.pop(context);
                return ProfilePage();

                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //
                //   return ProfilePage();
                //
                // })
                // );
              } else if (_currentIndex == 2) {
                _currentIndex = 1;
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Billing();
                }));
              }
            });
          },
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            StreamBuilder(
              stream: collection
                  .where("E-mail",
                      isEqualTo: FirebaseAuth.instance.currentUser.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading data");
                } else {
                  //
                  // var collectionsGroup = firestore.collectionGroup('Subscriptions').where('book_name', isNotEqualTo: null ).limit(4);
                  // collectionsGroup.get().then((List) => {
                  //   List.docs.forEach((doc) {
                  //     print(doc.data()['book_name']);
                  //     Text("Active subscriptions: ${doc.data()['book_name']}");
                  //   })
                  //
                  // });

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Text(
                          "Username: ${snapshot.data.docs[0]['name']}\nLast name: ${snapshot.data.docs[0]['Last name']}\n",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                            "Contact number: ${snapshot.data.docs[0]['Contact']}",
                            style: TextStyle(fontSize: 16.0)),
                        Text("Address: ${snapshot.data.docs[0]['Address']}",
                            style: TextStyle(fontSize: 16.0))

                        // Text("Date book rented: ${time}"),
                        // Text("Deadline: ${(snapshot.data.docs[0]['Return_deadline']).toDate()}")
                      ]));
                }
              },
            ),
            Text("Subscription information: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.pink,
                )),
            SizedBox(
              height: 15.0,
              width: 15.0,
            ),
            StreamBuilder(
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
                            final docId = snapshot.data.docs[index].id;

                            if (bookName.isNotEmpty) {
                              return Column(children: [
                                Center(
                                    child: Card(
                                        child: Text(
                                            'Books : ${bookName}\n Rented at: ${rentedAt}\n Retrun date is ${returnDate}\n '))),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Deleting!"),
                                              content: Text(
                                                  "Are you sure you want to delete?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      deleteRef
                                                          .collection(
                                                              'Subscriptions')
                                                          .doc(docId)
                                                          .delete();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Yes")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Cancel"))
                                              ],
                                            );
                                          });
                                    })
                              ]);
                            } else {
                              return Text("No subscriptions found!");
                            }
                          });
                    } else {
                      Text("Failed! Some error has occured...");
                    }
                }
                return null;
              },
            )

            // Container(
            //   child: StreamBuilder(
            //     stream: subCollection.where('book_name', isEqualTo: 'Sin Eater').snapshots(),
            //     builder: (context,snapshot) {
            //       if(!snapshot.hasData){
            //         return Text("Loading data");
            //       }
            //       else{
            //         Text("${snapshot.data.docs[0]['Books_subscribed']}");
            //       }
            //
            //     }
            //   ),
            // )
          ]),
        ));
  }

// Widget userData() {
//   firestore.collection('Users').doc(userID).get().then((value) {
//     return Column(
//       children: [
//         Text('Name:${value.data()['name']}')
//       ],
//     );
//   });
// }

}
