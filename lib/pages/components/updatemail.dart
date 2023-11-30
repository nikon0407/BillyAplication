import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeEmailPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Email'),backgroundColor: Color.fromRGBO(236, 144, 5, 100),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'New Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new email address';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _changeEmail(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(236, 144, 5, 100), side: BorderSide.none, shape: const StadiumBorder()),
                child: Text('Update Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get the current user
        User? user = _auth.currentUser;

        if (user != null) {
          // Update the user's email in Firebase Auth
          await user.updateEmail(_email);

          // Update the user's email in Firestore
          await _firestore.collection('UserData').doc(user.uid).update({
            'email': _email,
          });

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email updated successfully'),
              backgroundColor: Colors.green,
            ),

          );
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        // Show an error message if the update failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
