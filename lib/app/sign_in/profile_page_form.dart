import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth.dart';

class ProfilePageForm extends StatefulWidget {
  @override
  _ProfilePageFormState createState() => _ProfilePageFormState();
}

class _ProfilePageFormState extends State<ProfilePageForm> {


  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final currentDateTime = new DateTime.now();
  // final return_deadline = new DateTime.now().add(Duration(days: 3));

  final _emailHandler = FirebaseAuth.instance.currentUser.email;
  final _userID = FirebaseAuth.instance.currentUser.uid.toString();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lasttName = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _delivaryAddress = TextEditingController();

  List<Widget> _buildChildren(){
    return [
      _buildFirstNameTextField(),
      SizedBox(height: 30.0, width: 30.0,),
      _buildLastNameTextField(),
      SizedBox(height: 30.0, width: 30.0,),
      _contactInfoTextField(),
      SizedBox(height: 30.0, width: 30.0,),
      _addressTextField(),


      ElevatedButton(onPressed: () async {
        if(FirebaseAuth.instance.currentUser.email == null){
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error!"),
              content: Text("Sign in with your email First!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Return")
                )
              ],
            );
          });

        }
        else{
          firestore.collection('Users').doc(FirebaseAuth.instance.currentUser.uid).set({

            "name": _firstName.text,
            "Last name": _lasttName.text,
            "Contact": _contactNumber.text,
            "E-mail": _emailHandler,
            "Address":_delivaryAddress.text
            // "Current_time": currentDateTime,
            // "Return_deadline":return_deadline


          });



          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text("Data is saved!"),
              content: Text("We have saved your data"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("ok")
                )
              ],
            );
          });

        }


        // print(currentDateTime);
        _firstName.clear();
        _lasttName.clear();
        _contactNumber.clear();
        _delivaryAddress.clear();
      },
          child: Text("Submit details")
      ),



    ];
  }


  _buildFirstNameTextField() {
    return TextField(
      autofocus: false,
      controller: _firstName,
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter first name"
      ),
      textInputAction: TextInputAction.next,
    );

  }

  _buildLastNameTextField() {
    return TextField(
      autofocus: false,
      controller: _lasttName,
      decoration: InputDecoration(
          labelText: "Last Name",
          hintText: "Enter last name"
      ),
      textInputAction: TextInputAction.next,
    );
  }

  _contactInfoTextField(){
    return TextField(
      autofocus: false,
      controller: _contactNumber,
      decoration: InputDecoration(
        labelText: 'Contact number',
        hintText: "+91 123456789"
      ),
      textInputAction: TextInputAction.next,
    );
  }
  _addressTextField(){
    return TextField(
      autofocus: false,
      controller: _delivaryAddress,
      decoration: InputDecoration(
        labelText: 'Delivery address',
        hintText: 'Address to deliver you books',
      ),
    );
  }





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




}

