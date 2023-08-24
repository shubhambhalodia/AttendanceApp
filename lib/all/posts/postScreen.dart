import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../loginScreen.dart';
import '../utils/utils.dart';
import 'add_post_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth=FirebaseAuth.instance;
  final ref=FirebaseDatabase.instance.ref('post');
  final searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Post'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed:(){
            _auth.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          }, icon: Icon(Icons.logout))
        ],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
                onChanged: (String value){
                  setState(() {

                  });
                },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
            query: ref,
            defaultChild: Center(child: CircularProgressIndicator()),
            itemBuilder:(context,snapshot,animation,index){

              final title=Text(snapshot.child('title').value.toString());

              if(searchController.text.isEmpty){
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                );
              }
              else if(title.toString().toLowerCase().contains(searchController.text.toLowerCase().toString())){
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                );
                }
                else{
                  return Container();
              }
              }


          ),
          ),

        ],),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPostScreen()));

          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
