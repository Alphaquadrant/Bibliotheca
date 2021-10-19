import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/about.dart';
import 'package:flutter_app/app/sign_in/books_data.dart';
import 'package:flutter_app/app/sign_in/search_page.dart';
import 'book_data_holder.dart';
import 'package:flutter_app/app/sign_in/profile_page.dart';

import 'package:flutter_app/services/auth.dart';
import 'package:nice_button/nice_button.dart';
import 'data_holder.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Widget makeImageGrid() {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: 12,
        itemBuilder: (context, index) {
          return ImageGridItem(index + 1);
        });
  }

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser.displayName.toString();

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
          'Welcome,$userName',
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          // FlatButton(onPressed: () {
          //   _signOut();
          // },
          //
          //     child: Text('Logout!',
          //       style: TextStyle(fontSize: 25, color: Colors.greenAccent),)),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Search();
                }));
              }),
        ],
      ),

      drawer: Drawer(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text(""),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.blue],
                    ),
                    image: DecorationImage(
                      image: AssetImage('images/smallbookimage.png'),
                    ),
                    color: Colors.white),
              ),
              NiceButton(
                gradientColors: [Colors.blue, Colors.purple],
                width: 255,
                elevation: 8.0,
                radius: 40.0,
                text: "Profile",
                //background: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfilePage();
                  }));
                },
              ),
              SizedBox(
                height: 20.0,
                width: 20.0,
              ),
              NiceButton(
                gradientColors: [Colors.blue, Colors.purple],
                width: 255,
                elevation: 8.0,
                radius: 40.0,
                text: "About",
                background: Colors.blueAccent,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AboutUs();
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
                width: 20.0,
              ),
              NiceButton(
                gradientColors: [Colors.blue, Colors.purple],
                width: 255,
                elevation: 8.0,
                radius: 40.0,
                text: "Logout",
                background: Colors.blueAccent,
                onPressed: () {
                  _signOut();
                },
              ),
            ],
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(-1.0, -4.0),
                end: Alignment(1.0, 4.0),
                colors: [Colors.teal, Colors.tealAccent, Colors.teal])),
        child: makeImageGrid(),
      ),

      // body: homeContainer(),
    );
  }
}

class ImageGridItem extends StatefulWidget {
  int _index;

  ImageGridItem(int index) {
    this._index = index;
  }

  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  int _currentIndex = 0;

  Uint8List imageFile;
  Reference photosReference = FirebaseStorage.instance.ref().child("photos");

  getImage() {
    if (!requestedIndexes.contains(widget._index)) {
      int MaxSize = 7 * 1024 * 1024;
      photosReference
          .child("image_${widget._index}.jpg")
          .getData(MaxSize)
          .then((data) {
        this.setState(() {
          imageFile = data;
        });
        imageData.putIfAbsent(widget._index, () {
          return data;
        });
      }).catchError((onError) {
        debugPrint(onError.toString());
      });
      requestedIndexes.add(widget._index);
    }
  }

  Widget decideGridTileWidget() {
    if (imageFile == null) {
      return Center(child: Text('No data'));
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child: Image.memory(
          imageFile,
          fit: BoxFit.fill,
          height: 10.0,
          width: 5.0,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (!imageData.containsKey(widget._index)) {
      getImage();
    } else {
      this.setState(() {
        imageFile = imageData[widget._index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: GridTile(
          child: decideGridTileWidget(),
        ),
        onTap: () {
          _bookClickListener();
        },
      ),
    );
  }

  void _bookClickListener() {
    // print("clicked image ${widget._index} !");
    if (requestedBookIndexes.length > 1) {
      requestedBookIndexes.clear();
    } else {
      requestedBookIndexes.add(widget._index);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BookData();
    }));
  }
}

//
