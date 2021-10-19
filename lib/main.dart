import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/sign_in/landing_page.dart';

import 'package:flutter_app/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Library manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(
        auth: Authorization(),
      ),
    );
  }
}
