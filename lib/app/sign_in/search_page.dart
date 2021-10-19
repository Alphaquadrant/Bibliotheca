import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/searchService.dart';

import 'book_data_holder.dart';
import 'books_data.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(String value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot documents) {
        for (int i = 0; i < documents.docs.length; i++) {
          queryResultSet.add(documents.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['Book_name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
            // print("1!");
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.tealAccent,
        Colors.tealAccent,
        Colors.tealAccent
      ])),
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
          title: Text("Search"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: false,
                onChanged: (val) {
                  initiateSearch(val);
                },
                decoration:
                    InputDecoration(labelText: "Search", hintText: "book name"),
                textInputAction: TextInputAction.search,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                primary: false,
                shrinkWrap: true,
                children: tempSearchStore.map<Widget>((element) {
                  return buildResultCard(element);
                }).toList()),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget buildResultCard(element) {
    String imageUrl = element['imageUrl'];
    return GestureDetector(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
          ),
        ),
        onTap: () {
          String bookName = element['Book_name'];
          int _index = element['index'];
          print(_index);
          if (requestedBookIndexes.length > 1) {
            requestedBookIndexes.clear();
          }
          // else if(_index == 3){
          //   requestedBookIndexes.add(3);
          // }
          else {
            requestedBookIndexes.add(_index);
          }

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BookData();
          }));
        });
  }
}
