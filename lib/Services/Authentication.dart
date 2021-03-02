import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//We are using FireBaseAuth and Email API for Sign Up,Sign In and Sign Out
class Authentication{

    Future<void> signUp(String username,String password) async {
        FirebaseUser user= (await FirebaseAuth.instance.
                              createUserWithEmailAndPassword(email: username, password: password)).user;
        return user;
  }
     Future signIn (TextEditingController username,TextEditingController password)async{
      try{
        FirebaseUser user= (await FirebaseAuth.instance.
                              signInWithEmailAndPassword(email: username.text, password: password.text)).user;
        return user;
      }catch(e){
          print(e.message);
      }
    }
   Future signOut() async {
        return FirebaseAuth.instance.signOut();
    }
}