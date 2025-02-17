import 'package:billy/pages/HomePage.dart';
import 'package:billy/pages/LoginOrRegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //user is logged in
          if (snapshot.hasData){
            return HomePage();
          }
          //user is not logged
          else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
