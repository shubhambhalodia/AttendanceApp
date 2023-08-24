import 'package:attendence_flutter/all/posts/add_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'all/signupScreen.dart';


class AdminScreen extends StatelessWidget {
   AdminScreen({super.key})
   {
     _stream=_reference.snapshots();
   }
   CollectionReference _reference = FirebaseFirestore.instance.collection('attendence');
   late Stream<QuerySnapshot> _stream;
   // late DocumentReference _documentReference;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white70,
      appBar: AppBar(title: Text('Admin Screen'),),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            QuerySnapshot<Object> querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Convert the documents to Maps
            List<Map> items = documents.map((e) => e.data() as Map).toList();

            //Display the list
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  //Get the item at this index
                  Map thisItem = items[index];
                  //REturn the widget for the list items
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.white70,
                              borderRadius: BorderRadius.circular(28),),
                            child: thisItem.containsKey('image') ? Image.network(
                                '${thisItem['image']}') : Container(),
                          ),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                            Text('${thisItem['name']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              Text('${thisItem['time']}',style: TextStyle(color: Colors.black87),),
                              Text('${thisItem['address']}',style: TextStyle(color: Colors.black87),),

                          ],)),

                        ],),
                      ),


                    ),
                  );
                });
          }

          return const Center(
                child: CircularProgressIndicator()
            );

        },
      ),
    );
  }
}
