import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/home_page.dart';
import 'package:flutter_app/app/sign_in/sign_in_page.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:image_picker/image_picker.dart';


class Librarian extends StatefulWidget {
  @override
  _LibrarianState createState() => _LibrarianState();
}

class _LibrarianState extends State<Librarian> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _bookId = TextEditingController();
  final TextEditingController _bookName = TextEditingController();
  final TextEditingController _noOfCopies = TextEditingController();
  final TextEditingController _summary = TextEditingController();
  final TextEditingController _collectionName = TextEditingController();
  final TextEditingController _imageIndex = TextEditingController();
  PickedFile _image;
  
  List <Widget> _buildChildren(){
    return[
      _buildBookIdTextField(),
      SizedBox(height: 30.0, width: 30.0,),
      _buildBookNameTextField(),
      SizedBox(height: 30.0, width: 30.0,),
      _noOfCopiesField(),
      SizedBox(height: 30.0, width: 30.0,),
      _SummaryField(),
      SizedBox(height: 30.0, width: 30.0,),
      _collectionNameField(),
      SizedBox(height: 30.0, width: 30.0,),
      _imageNumberField(),
      
      ElevatedButton(onPressed: () async {
        firestore.collection('Books').doc(_collectionName.text).set({
          'Book_id': _bookId.text,
          'Book_name': _bookName.text,
          'No_of_copies': int.parse(_noOfCopies.text),
          'Summary':_summary.text
        });
        _bookId.clear();
        _bookName.clear();
        _noOfCopies.clear();
        _summary.clear();
        _collectionName.clear();
        
      },
          child: Text("upload data"))
    ];
    
  }

  Future uploadImage() async{
    // String fileName = basename(_image.path);
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("Image name ");
    });
  }

  Future uploadImageToFirebase() async{
    String fileName = basename(_image.path);
    File storedImage = File(_image.path);
    int filelength = fileName.length;
    int imageNumber = int.parse(_imageIndex.text);
    String imageIndex = fileName.substring(0,6)+"${imageNumber}.jpg";
    print(fileName.length);
    String collectionName = imageIndex.substring(0,1).toUpperCase() + imageIndex.substring(1,7);


    Reference imageStorageRef = FirebaseStorage.instance.ref().child('photos').child(imageIndex);
    UploadTask imageUpload = imageStorageRef.putFile(storedImage);
    TaskSnapshot taskSnapshot = await imageUpload;
    taskSnapshot.ref.getDownloadURL().then((value) => print("Done: $value"));

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin panel"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children:[ Container(
              child: ElevatedButton(
                child: Text("Select image"),
                onPressed: () {
                  uploadImage();
                  
                },
              ),

            ),
              Container(
                child: ElevatedButton(
                  child: Text("Upload image"),
                  onPressed: () {
                    uploadImageToFirebase();
                    
                  },
                ),

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: _buildChildren(),
                ),
              ),

    ]
          ),
        ),
      ),
    );
  }

  _buildBookIdTextField() {
    return TextField(
      autofocus: false,
      controller: _bookId,
      decoration: InputDecoration(
          labelText: "Book Id",
          hintText: "Enter book Id"
      ),
      textInputAction: TextInputAction.next,
    );
  }

  _buildBookNameTextField() {
    return TextField(
      autofocus: false,
      controller: _bookName,
      decoration: InputDecoration(
          labelText: "Book name",
          hintText: "Enter book name"
      ),
      textInputAction: TextInputAction.next,
    );

  }

  _noOfCopiesField() {
    return TextField(
      autofocus: false,
      controller: _noOfCopies,
      decoration: InputDecoration(
          labelText: "Number of copies",
          hintText: "Copies"
      ),
      textInputAction: TextInputAction.next,

    );

  }

  _SummaryField() {
    return TextField(
      autofocus: false,
      controller: _summary,
      decoration: InputDecoration(
          labelText: "Book summary",
          hintText: "Enter book summary"
      ),
      textInputAction: TextInputAction.next,

    );

  }

  _collectionNameField() {
    return TextField(
      autofocus: false,
      controller: _collectionName,
      decoration: InputDecoration(
          labelText: "Database collection name",
          hintText: "Image_index"
      ),
      textInputAction: TextInputAction.next,

    );
  }

  _imageNumberField() {
    return TextField(
      autofocus: false,
      controller: _imageIndex,
      decoration: InputDecoration(
          labelText: "Image number",
          hintText: ""
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,

    );

  }




}
