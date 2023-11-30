import 'package:billy/pages/components/signbutton.dart';
import 'package:billy/pages/components/square_tile.dart';
import 'package:billy/pages/components/text_field.dart';
import 'package:billy/pages/forgot_password_page.dart';
import 'package:billy/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
        },
    );


    // try sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //wrong email
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      }
      //wrong password
      else if(e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
    //pop loading circle
    Navigator.pop(context);
  }
  
  //wrong email message popup
  void wrongEmailMessage() async {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Incorect Email'),
          );
        },
    );
  }
  void wrongPasswordMessage() async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorect Password'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Container(
                  child: Image.asset('assets/images/logo.png', height: 200,),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[900]
                  ),
                ),
                const SizedBox(height: 30),
                const SizedBox( height: 50),

                //user email
                Textfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox( height: 10),
                //user password
                Textfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox( height: 10),
                //forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (contex){
                            return ForgotPasswordPage();
                            },
                          ),
                          );
                          },
                        child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                const SizedBox( height: 25),

                //sign button
                MyButton(
                  text: "Log in",
                  onTap: signUserIn,
                ),

                const SizedBox( height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or continue with', style: TextStyle(color: Colors.grey[700]),),
                      ),

                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),),
                    ],
                  ),
                ),
                const SizedBox( height: 30),
                //google or apple
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'assets/images/google.png'),
                    SizedBox( width: 10),
                    ],
                ),
                const SizedBox( height: 30),
                //not member
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),),
                    ),
                  ],
                )
            ],),
          ),
        ),
      )
    );
  }
}