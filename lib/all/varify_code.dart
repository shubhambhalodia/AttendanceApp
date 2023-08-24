import 'package:attendence_flutter/all/posts/add_post_screen.dart';
import 'package:attendence_flutter/all/posts/postScreen.dart';
import 'package:attendence_flutter/all/utils/utils.dart';
import 'package:attendence_flutter/all/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VarifyCodeScreen extends StatefulWidget {
  const VarifyCodeScreen({super.key, required this.verificationid});

  final String verificationid;
  @override
  State<VarifyCodeScreen> createState() => _VarifyCodeScreenState();
}

class _VarifyCodeScreenState extends State<VarifyCodeScreen> {
  final verifyController=TextEditingController();
  bool isloading=false;
  final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            TextFormField(
              controller: verifyController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: '6 digit code',
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(
              title: 'Verify',
              loading: isloading,
              onTap: () async{
                setState(() {
                  isloading=true;
                });
                final credential=PhoneAuthProvider.credential(
                    verificationId: widget.verificationid,
                     smsCode: verifyController.text.toString());
                try{
                  await _auth.signInWithCredential(credential);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPostScreen()));
                }catch(e){
                      setState(() {
                        isloading=false;
                      });
                      Utils().toastMessage(e.toString());
                }
              },
            )
          ],),
      ),
    );
  }
}

