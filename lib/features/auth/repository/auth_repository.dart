import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';

//FirebaseFirestore.instance-> instead of writing like this I will create provider of firestore as well. I am doing this as agr maine instance wla tareeka leliya then everytime the widget tree or screen rebuilds every time hme instance create krna pdega

final AuthRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      //private variables ki values mai simply constructor se 'this.auth' krke mahi mngva skta isliye mine same naam ke normal variables bna liye aur unki values ko private variables mei assign krdiya
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  void signInWithGoogle() async {
    try {
      // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId:'283138086066-lqp37bul8a212m6pipd1p6npqcak11fu.apps.googleusercontent.com' //I added this client id by enabling google people API from this line "https://console.cloud.google.com/apis/api/people.googleapis.com/metrics?project=reddit-clone-7d308" this thing was not done by rivaan by I was getting error without this
      ).signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      print(userCredential.user?.email);
    } catch (e) {
      print(e);
    }
  }
}
