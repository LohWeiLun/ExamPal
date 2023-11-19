import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exampal/Resouces/storage_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future <String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  })async{
    String res = "Some error occured";
    try{
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && file != null){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password,);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        _firestore.collection('user').doc(cred.user!.uid).set({
          'username' : username,
          'uid': cred.user!.uid,
          'email': email,
          'followers':[],
          'following':[],
          'photoUrl':photoUrl,
        });

        /*
        await _firestore.collection('user').add({
          'username' : username,
          'uid': cred.user!.uid,
          'email': email,
          'bio' :bio,
          'followers':[],
          'following':[],
        });
         */
        res = 'success';
      }
    }on FirebaseAuthException catch(err){
      if(err.code == 'invalid-email'){
        res = 'The email is badly formatted.';
      }else if (err.code == 'weak-password'){
        res = 'Password should be at least 6 characters';
      }
    }

    catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}