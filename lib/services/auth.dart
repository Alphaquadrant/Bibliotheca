import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase{
  User get currentUser;
  Stream <User> authStateChanges();
  Future <User> signInAnonymously();
  Future <void> signOut();
  Future <User> googleSignIn();
  Future <User> facebookSignIn();
  Future <User> signInWithEmailAndPassword(String email, String password);
  Future <User> createUserWithEmailAndPassword(String email, String password);


}

class Authorization implements AuthBase{
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Stream <User> authStateChanges() => _firebaseAuth.authStateChanges();
  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future <User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future <User> googleSignIn() async{
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if(googleUser != null){
      final googleAuth = await googleUser.authentication;
      if(googleAuth.idToken != null){
        final userCredential = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      }
      else{
        throw FirebaseAuthException(message: 'No google ID token!', code: 'ERROR_NO_GOOGLE_IDtOKEN');
      }
    }
    else {
      throw FirebaseAuthException(
          message: "Sign in aborted by user!", code: 'ERROR_ABORTED_BY_USER');
    }
  }

  @override
  Future <User> facebookSignIn() async{
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);
    switch(response.status){
      case FacebookLoginStatus.Success:
        final accesToken = response.accessToken;
        final userCredentials = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.credential(accesToken.token),);
        return userCredentials.user;


      case FacebookLoginStatus.Cancel:
        throw FirebaseAuthException(
          code: 'ERROR_LOGIN_FAILED_Aborted',
          message: 'user aborted'
        );



      case FacebookLoginStatus.Error:
        throw FirebaseAuthException(
          code: 'ERROR_LOGIN_FAILED',
          message: response.error.developerMessage
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future <User> signInWithEmailAndPassword(String email, String password) async{
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password)
    );
    return userCredential.user;
  }

  @override
  Future <User> createUserWithEmailAndPassword(String email, String password) async{
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }


  @override
  Future <void> signOut() async {
    final googleSignIn = GoogleSignIn();
    final facebookLogin = FacebookLogin();

    await googleSignIn.signOut();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}