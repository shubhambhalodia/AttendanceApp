import 'dart:async';

import 'package:attendence_flutter/all/posts/add_post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loginScreen.dart';
import '../posts/postScreen.dart';

class SplashServices{

  void isLogin(BuildContext context){

    final _auth=FirebaseAuth.instance;
    final user=_auth.currentUser;

    if(user!=null){
      Timer(const Duration(seconds: 1),()=>
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPostScreen()))
      );
    }
    else {
      Timer(const Duration(seconds: 1), () =>
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()))
      );
    }
  }
}