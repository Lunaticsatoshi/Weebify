import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebify/models/user_data.dart';

class AuthService {
  
  static final _auth = FirebaseAuth.instance;
  static final _fireStore = Firestore.instance;

  static void signUPUser(BuildContext context, String name, String email, String password ) async{
     try {
         AuthResult authResult = await _auth.createUserWithEmailAndPassword(
           email: email,
           password: password
         );
         FirebaseUser signedInUser = authResult.user;
         if (signedInUser != null){
           _fireStore.collection('/users').document(signedInUser.uid).setData({
            'name': name,
            'email': email,
            'profileImage': '',
           });
           Provider.of<UserData>(context).currentUserId = signedInUser.uid;
           Navigator.pop(context);
         }
     } catch(e){
       print(e);
     }
  }

  static void logOut(BuildContext context){
    _auth.signOut();
  }

  static void login(String email, String password) async {
    try {
     await _auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      print(e);
    }
  }
}