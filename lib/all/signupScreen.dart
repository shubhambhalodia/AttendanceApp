import 'package:attendence_flutter/all/utils/utils.dart';
import 'package:attendence_flutter/all/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'loginScreen.dart';
final emailController=TextEditingController();
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final passwordController= TextEditingController();
  final validatePassController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  FirebaseAuth _auth= FirebaseAuth.instance;
  bool isLoading=false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Sign Up"),),
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
                    const SizedBox(height: 10),

                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: validatePassController,
                      obscureText: true,
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.lock),hintText: 'Re-enter Password',),
                      validator: (value){
                        if(value!.isEmpty) {
                          return 'enter value';
                        }
                        else if(validatePassController.value!=passwordController.value){
                          return 'you have enter different password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30,),
                    RoundButton(
                        loading: isLoading,
                        title: 'Sign up',onTap: (){
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          isLoading=true;
                        });
                          _auth.createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString())
                          .then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                            setState(() {
                              isLoading=false;
                            });
                          })
                              .onError((error, stackTrace) { Utils().toastMessage(
                              error.toString()
                          );
                              setState(() {
                                isLoading=false;
                              });});


                          }



                      }
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        const Text("already have an account?"),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                        }, child: const Text('Log in'))
                      ],),


                  ],
                  )
              )

            ],),
        ),

    );
  }
}
