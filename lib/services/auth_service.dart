import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService {

  //google sign in
  signInWithGoogle() async {
    //begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    // finally lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      FirebaseFirestore.instance.collection('UserData').doc(value.user!.uid).set({
        'userName': gUser.displayName,
        'userLastName': (''),
        'email':gUser.email,
        'uid': value.user!.uid
      });
    });
  }
}
