import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../adminScreen.dart';
import '../loginScreen.dart';
import '../utils/utils.dart';
import '../widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});


  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

Future<Position> _getCurrentLocation() async{
  bool serviceEnabled=await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    return Future.error('Location service are disabled');
  }
  LocationPermission permission=await Geolocator.checkPermission();
  if(permission==LocationPermission.denied){
    permission=await Geolocator.requestPermission();
    if(permission==LocationPermission.denied){
      return Future.error('location permission are denied');
    }
  }
  if(permission==LocationPermission.deniedForever){
    return Future.error('Location permission are permanently denied');
  }
  return await Geolocator.getCurrentPosition();
}

class _AddPostScreenState extends State<AddPostScreen> {
  // final databaseRef=FirebaseDatabase.instance.ref('post');//realtime
  FirebaseAuth _auth=FirebaseAuth.instance;
  bool isPhotoCheck = false;
  var postController=TextEditingController();
  CollectionReference _referenceShoppingList=FirebaseFirestore.instance.collection('attendence');
  bool isloading=false;
  String imageUrl='';
  late XFile? file;
 late var lat;
  late var lon;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('add post'),
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: postController,
                decoration: InputDecoration(
                  hintText: 'Write your Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              IconButton(onPressed: () async{
                setState(() {
                  _getCurrentLocation().then((value) {
                    lat= value.latitude;
                    lon = value.longitude;
                  }
                  );
                });
                ImagePicker imagePicker=ImagePicker();
                file=await imagePicker.pickImage(source: ImageSource.camera);
                print('this is messageeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
                print('${file?.path}');
                if(file==null)return;

                String uniqueFileName=DateTime.now().millisecondsSinceEpoch.toString();
                Reference referenceRoot=FirebaseStorage.instance.ref();
                Reference referenceDirImages=referenceRoot.child('images');
                Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);

                try{

                  Utils().toastMessage("image is uploading... ");
                  await referenceImageToUpload.putFile(File(file!.path));
                  imageUrl=await referenceImageToUpload.getDownloadURL();
                  // print("messagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessage");
                  Utils().toastMessage('you have succesfully uploaded the photo');
                }catch(error){
                  Utils().toastMessage(error.toString());
                }



              }, icon: Icon(Icons.camera_alt)),

              SizedBox(height: 30),

              RoundButton(title: 'add', onTap:() async{



              if (imageUrl.isEmpty) {
                ScaffoldMessenger.of(context)
                  .showSnackBar(
                      SnackBar(content: Text('Please upload an image')));
                return;
                      }

              List<Placemark>placemarks= await placemarkFromCoordinates(lat, lon);
              Placemark place =placemarks[0];
              String address=place.locality.toString() +", "+place.country.toString();
              String name=postController.text;
              final now = DateTime.now();
              final time=now.timeZoneOffset;
              print('messageegeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
              print(now);
                      Map<String, String> dataToSend = {
                      'name': postController.text,
                        'time':now.toString(),
                        'image': imageUrl,
                        'address':address,
                      };

                        try {
                    FirebaseFirestore.instance.collection('attendence').add(
                        dataToSend);
                    Timer(Duration(seconds: 1), () =>
                        Utils().toastMessage(
                            "post has been successfully added"));
                  } catch (e) {
                    Utils().toastMessage(e.toString());
                  }
                }
              ),



              SizedBox(height: 30),
              RoundButton(title: 'Admin screen',onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminScreen()));}),
            ],
          ),
        ),
      ),
    );
  }
}
