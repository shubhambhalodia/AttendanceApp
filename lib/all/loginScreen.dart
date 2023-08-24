import 'package:attendence_flutter/all/posts/add_post_screen.dart';
import 'package:attendence_flutter/all/posts/postScreen.dart';
import 'package:attendence_flutter/all/signupScreen.dart';
import 'package:attendence_flutter/all/utils/utils.dart';
import 'package:attendence_flutter/all/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'login_with_phone.dart';
late final user;
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final emailController=TextEditingController();
  final passwordController= TextEditingController();
  final _formKey=GlobalKey<FormState>();
  FirebaseAuth _auth=FirebaseAuth.instance;
  bool isloading=false;
  bool isTaping=false;




  void login() async{
    setState(() {
      isloading=true;
    });
    _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text.toString())
    .then((value) { Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPostScreen()));



          // print("Message ===> ${value}");

          setState(() {
            isloading=false;
          });
    })
        .onError((error, stackTrace) {Utils().toastMessage(error.toString());
        setState(() {
          isloading=false;
        });
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("login"),automaticallyImplyLeading: false,),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email)),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'enter email';
                    }
                    else if(!value.contains('gmail.com')){
                      return 'email badly formatted';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.lock),hintText: 'Password',),
                  validator: (value){
                    if(value!.isEmpty) {
                      return 'enter password';
                    }
                    else if(value.length<6){
                      return 'password must contain atleast 6 letters';
                    }
                    return null;
                  },
                ),
                       const SizedBox(height: 30,),

                      RoundButton(loading:isloading ,title: 'Login',onTap: (){
                  if(_formKey.currentState!.validate()){
                        login();
                  }
                },
                ),
                     SizedBox(height: 20),
                     Row(
                       mainAxisAlignment:MainAxisAlignment.center,
                       children: [
                      const Text("don't have an account?"),
                      TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                      }, child: const Text('Sign up'))
                    ],
                     ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithPhone()));


                        setState(() {
                          isTaping=true;
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black54),
                          color: isTaping?Colors.deepPurple : Colors.white,
                        ),
                        child: Center(child: Text('Login with Phone')),
                      ),
                    ),
                    
              ],
                  )
              )

          ],),
        ),
      ),
    );
  }
}
