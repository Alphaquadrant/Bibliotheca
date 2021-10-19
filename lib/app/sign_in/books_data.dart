import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'book_data_holder.dart';

class BookData extends StatefulWidget {
  @override
  _BookDataState createState() => _BookDataState();
}

class _BookDataState extends State<BookData> {
  int requirement = 0;
  String newValue;
  int imageIndex = (requestedBookIndexes.removeAt(0));
  String uid = FirebaseAuth.instance.currentUser.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentDateTime = new DateTime.now();
  final return_deadline = new DateTime.now().add(Duration(days: 3));

  Uint8List bookImages;

  // static Reference  imageURL = FirebaseStorage.instance.ref().child('photos/image_${imageIndex}.jpg');
  Reference booksreference = FirebaseStorage.instance.ref().child("photos");

  // var URL = imageURL.getDownloadURL().toString();
  CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('Books');
  CollectionReference userRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('Subscriptions');

  getBookData() {
    int maxSize = 7 * 1024 * 1024;
    booksreference
        .child("image_${imageIndex}.jpg")
        .getData(maxSize)
        .then((data) {
      this.setState(() {
        bookImages = data;
      });
      bookImageData.putIfAbsent(imageIndex, () {
        return data;
      });
    }).catchError((onError) {
      debugPrint(onError.toString());
    });
  }

  Widget decideBookImage() {
    if (bookImages == null) {
      return Center(child: Text('Loading'));
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Container(
          height: 300,
          width: 400,
          child: ColoredBox(
            color: Colors.tealAccent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150.0),
              child: Image.memory(
                bookImages,
                fit: BoxFit.fitHeight,
                // height: 100,
                // width: 20,
              ),
            ),
          ),
        ),
      );
      // shadowColor: Colors.black,
      // elevation: 100.0,
      //
    }
  }

  void initState() {
    super.initState();
    if (!bookImageData.containsKey(imageIndex)) {
      getBookData();
    } else {
      this.setState(() {
        bookImages = bookImageData[imageIndex];
      });
    }
  }

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
        title: Text("Book details"),
      ),
      backgroundColor: Colors.tealAccent,
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 10,
              width: 20,
            ),
            Center(child: decideBookImage()),
            StreamBuilder(
                stream: booksCollection
                    .where('Book_id', isEqualTo: "image_${imageIndex}")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return CircularProgressIndicator();

                  int totalCopies = (snapshot.data.docs[0]['No_of_copies']);
                  var name = (snapshot.data.docs[0]['Book_name']);
                  var currentBookRented = (snapshot.data.docs[0]['Book_name']);

                  if (!snapshot.hasData) {
                    return Text("Loading data");
                  } else {
                    return Column(children: [
                      Text("Summary: ${snapshot.data.docs[0]['Summary']}",
                          style: TextStyle(fontSize: 18)),
                      Text("Name: ${snapshot.data.docs[0]['Book_name']}",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(
                        height: 20.0,
                        width: 20.0,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            print("Subscribed");

                            rentThisBook(name, totalCopies, currentBookRented,
                                requirement);
                          },
                          child: Text("Rent it!")),
                      SizedBox(
                        height: 10.0,
                        width: 10.0,
                      ),
                      Text("No of copies"),
                      new DropdownButton<String>(
                        hint: Text('Copies?'),
                        onChanged: (String changedValue) {
                          newValue = changedValue;
                          setState(() {
                            newValue;
                            // print(newValue);
                          });
                        },
                        value: newValue,
                        items: <String>['1', '2', '3', '4'].map((String value) {
                          return new DropdownMenuItem<String>(
                            onTap: () {
                              requirement = int.parse(value);
                            },
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        dropdownColor: Color.alphaBlend(
                            Colors.tealAccent, Colors.blueGrey),
                      ),
                    ]);
                  }
                }),
          ]),
        ),
      ),
    );
  }

  rentThisBook(var bookName, int bookCopies, var alreadyRentedBook,
      int booksSubscribed) {
    firestore
        .collection('Users')
        .doc(uid)
        .collection('Subscriptions')
        .get()
        .then((snap) {
      int size = snap.size;
      if (FirebaseAuth.instance.currentUser.email == null) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("No user found!"),
                  content: Text("Anynymous users cannot rent.\n Sign in first"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("ok"))
                  ]);
            });
      } else {
        if (size > 4) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text("Error!"),
                    content: Text("You have reached your renting limit"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Come back later.."))
                    ]);
              });
          print("no more subscriptions allowed");
        } else {
          if (bookCopies <= 0) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Out of stock!"),
                      content: Text("It seems we have run out of stock!"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Come back later.."))
                      ]);
                });
            print("We have run out of stock");
            firestore
                .collection('Books')
                .doc('Image_${imageIndex}')
                .update({"No_of_copies": 0});
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Alright!"),
                    content:
                        Text("We will try to deliver your books A.S.A.P!!"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Ok"))
                    ],
                  );
                });

            firestore
                .collection('Books')
                .doc('Image_${imageIndex}')
                .update({"No_of_copies": bookCopies - booksSubscribed});

            // firestore.collection('Users').doc(Uid).update({
            //
            //
            //
            //   "Book_name": bookName
            // });
          }

          firestore
              .collection('Users')
              .doc(uid)
              .collection('Subscriptions')
              .doc()
              .set({
            "book_name": bookName,
            "User-Id": uid,
            "Rented_at": currentDateTime,
            "Return_deadline": return_deadline,
            "Books_subscribed": booksSubscribed,
            // "Days_late_toReturn":
          });
        }
      }
    });
  }
}
