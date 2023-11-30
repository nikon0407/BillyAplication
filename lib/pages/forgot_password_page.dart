import 'package:billy/pages/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text('Password reset link sent! Check your email'),
            title: Text('Sent successfully!'),
          );
          },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text(e.message.toString()),
              title: Text('ERROR!'),
            );

          },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xEC9005),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            'Enter your Email and we will send you a password reset link!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),),
        ),
        SizedBox(height: 10,),
        //user email
        Textfield(
          controller: emailController,
          hintText: 'Email',
          obscureText: false,
        ),
          SizedBox(height: 10,),
        MaterialButton(
          onPressed: passwordReset,
          child: Text('Reset Password'),
          color: Colors.amberAccent[400],
        ),
      ],
      ),
    );
  }
}
