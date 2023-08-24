
import 'package:attendence_flutter/all/utils/utils.dart';
import 'package:attendence_flutter/all/varify_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/round_button.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final phoneController=TextEditingController();
  bool isloading=false;
  final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: '+91 235 6565 989',
                  ),
                ),
          SizedBox(height: 30,),
          RoundButton(
            title: 'Login',
            loading: isloading,
            onTap: (){
              setState(() {
                isloading=true;
              });
              _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                  verificationCompleted: (_){
                  setState(() {
                    isloading=false;
                  });
                  },
                  verificationFailed: (e){
                    setState(() {
                      isloading=false;
                    });
                  Utils().toastMessage(e.toString());
                  },
                  codeSent: (String verificationId,int? token){
                    setState(() {
                      isloading=false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    VarifyCodeScreen(verificationid: verificationId,)
                    ));

                  },
                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      isloading=false;
                    });
                  Utils().toastMessage(e.toString());
                  },
              );
            },
          )
        ],),
      ),
    );
  }
}
