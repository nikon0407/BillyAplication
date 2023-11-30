import 'package:billy/pages/HomePage.dart';
import 'package:billy/pages/auth_page.dart';
import 'package:billy/pages/help.dart';
import 'package:billy/pages/nfc.dart';
import 'package:billy/pages/addreceipt.dart';
import 'package:billy/pages/profile.dart';
import 'package:billy/pages/your_receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final user = FirebaseAuth.instance.currentUser!;
  String? name = '';
  String? lastname = '';
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
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthPage()));
  }
  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name!+' '+lastname!),
            accountEmail: Text(user.email!),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),

            decoration: BoxDecoration(
              color: Color(0xFF17203A),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add_a_photo),
            title: Text('Add Receipts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddReceiptPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long_rounded),
            title: Text('Yours Receipts'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ReceiptPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.nfc_rounded),
            title: Text('NFC'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NFCPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('ContactUs'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUs()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('LogOut'),
            onTap:signUserOut,
          ),
        ],
      ),
    );
  }
}
