import 'package:billy/pages/auth_page.dart';
import 'package:billy/pages/components/editprofile.dart';
import 'package:billy/pages/components/sidemenu.dart';
import 'package:billy/pages/help.dart';
import 'package:billy/pages/your_receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? name = 'nikon';
  String? lastname = 'nikon';

  Future _getDataFromDatabase() async{
    await FirebaseFirestore.instance.collection("UserData")
        .doc(user.uid)
        .get()
        .then((snapshot) async {
      if(snapshot.exists){
        setState(() {
          name = snapshot.data()!['userName'];
          lastname = snapshot.data()!['userLastName'];
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
      drawer: SideMenu(),
      appBar: AppBar(title: Text('Profile'),backgroundColor: Color.fromRGBO(236, 144, 5, 100),),

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

              const SizedBox(height: 10,),
              Text(name!+' '+lastname!,style: Theme.of(context).textTheme.headlineMedium,),
              Text(user.email!,style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child:
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfilePage()));
                  },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(236, 144, 5, 100),
                        side: BorderSide.none, shape: const StadiumBorder()),
                    child: const Text('Edit Profile', style: TextStyle(color: Colors.black),)
              ),
              ),
              const SizedBox(height: 30,),
              const Divider(),
              const SizedBox(height: 30,),
              ListTile(
                leading: Icon(Icons.receipt_long_rounded),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ReceiptPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.person_search_outlined),
                title: Text('User Management'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ReceiptPage()));
                },
              ),
              const SizedBox(height: 5,),
              const Divider(),
              const SizedBox(height: 5,),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Information'),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ContactUs()));
                },
              ),
              const SizedBox(height: 5,),
              const Divider(),
              const SizedBox(height: 5,),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthPage()));
                  } catch (e) {
                    print(e.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
