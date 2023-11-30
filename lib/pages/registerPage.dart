import 'package:billy/pages/components/signbutton.dart';
import 'package:billy/pages/components/square_tile.dart';
import 'package:billy/pages/components/text_field.dart';
import 'package:billy/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
  }

  void signUserUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // try creating user
    try{
      //check if password are same
      if (passwordConfirmed()) {
        //create user
         FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text).then((value){
            FirebaseFirestore.instance.collection('UserData').doc(value.user!.uid).set({
              'userName': firstNameController.text.trim(),
              'userLastName': lastNameController.text.trim(),
              'email':emailController.text.trim(),
              'password': passwordController.text.trim(),
              'age': int.parse(ageController.text.trim()),
              'uid': value.user!.uid
            });
         });
      }

    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
    }
  }

  bool passwordConfirmed() {
    if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
      return true;
    } else
      return false;
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
                  //text
                  Text('Let\'s create an account for you!',
                      style: TextStyle(color: Colors.grey[700],
                        fontSize: 16,)
                  ),
                  const SizedBox( height: 30),
                  //user name
                  Textfield(
                    controller: firstNameController,
                    hintText: 'Name',
                    obscureText: false,
                  ),
                  const SizedBox( height: 10),
                  //user last name
                  Textfield(
                    controller: lastNameController,
                    hintText: 'Last Name',
                    obscureText: false,
                  ),
                  const SizedBox( height: 10),
                  //user age
                  Textfield(
                    controller: ageController,
                    hintText: 'Age',
                    obscureText: false,
                  ),
                  const SizedBox( height: 10),
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
                  //user password confirm
                  Textfield(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox( height: 25),

                  //sign button
                  MyButton(
                    text: "Sign Up",
                    onTap: signUserUp,
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
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  const SizedBox( height: 30),
                ],),
            ),
          ),
        )
    );
  }
}