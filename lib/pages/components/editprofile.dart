import 'package:billy/pages/components/signbutton.dart';
import 'package:billy/pages/components/updatemail.dart';
import 'package:billy/pages/components/updatepassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}


void setState(Null Function() param0) {
}

class _EditProfilePageState extends State<EditProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? name = '';
  String? lastname = '';
  String? age = '';
  String? email = '';

  Future _getDataFromDatabase() async{
    await FirebaseFirestore.instance.collection("UserData")
        .doc(user.uid)
        .get()
        .then((snapshot) async {
      if(snapshot.exists){
        setState(() {
          name = snapshot.data()!['userName'];
          lastname = snapshot.data()!['userLastName'];
          age = snapshot.data()!['age'];
          email = snapshot.data()!['email'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),backgroundColor: Color.fromRGBO(236, 144, 5, 100),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
          Stack(
          children: [
          SizedBox(
          width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const Image(image:
              AssetImage('assets/images/kisspng-avatar-user.png')),),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color.fromRGBO(236, 144, 5, 100),),
              child: const Icon(
                CupertinoIcons.pencil,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          ],
          ),
              const SizedBox(height: 20,),
              const Divider(),
              MyButton(
                text: "Change Email",
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChangeEmailPage()));
                },
              ),
              const SizedBox( height: 10),
              //user password
              MyButton(
                text: "Change Password",
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChangePasswordPage()));
                },
              ),
              const SizedBox( height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
