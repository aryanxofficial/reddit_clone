import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/model/user_model.dart';

import '../../../core/constants/constants.dart';

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

  //CollectionReference is a class from the Firebase Firestore library. It represents a reference to a
  // specific collection in the Firestore database.
  CollectionReference get _users => _firestore.collection(FirebaseConstants
      .usersCollection); //maine alg se class bnakr waha se call kiya hai coz it is a better convention and also reduces spelling mistakes
  /*
   when you call the users getter on an instance of the class where this code is defined, 
   it will return a reference to the 'users' collection in the Firestore database.
   This allows you to perform Firestore database operations on the 'users' collection, 
   such as querying for documents, adding documents, or updating documents within that collection.
  */

  void signInWithGoogle() async {
    try {
      // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              //got this client id from google api console

              clientId:
                  '283138086066-lqp37bul8a212m6pipd1p6npqcak11fu.apps.googleusercontent.com' //I added this client id by enabling google people API from this line "https://console.cloud.google.com/apis/api/people.googleapis.com/metrics?project=reddit-clone-7d308" this thing was not done by rivaan by I was getting error without this
              )
          .
          /*
      Use `signInSilently` and `renderButton` to authenticate your users instead.
      This warning is suggesting that the signIn method, which you are using to initiate Google Sign-In, is discouraged on web platforms because it may not reliably provide an idToken. The idToken is essential for certain authentication and authorization scenarios.

      The recommended alternatives mentioned in the warning are:

      signInSilently: This method is used to silently check if the user is already signed in without displaying a pop-up.
      renderButton: This method is used to render a Google Sign-In button, which is a user-friendly way to initiate sign-in.
      */
          signIn(); //does not provide me with an id token
      // signInSilently(); //with this line pop is not showing up

      final googleAuth = await googleUser?.authentication;

      // final accessToken1 = googleAuth?.accessToken;
      // final idToken = googleAuth?.idToken;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // _firestore.collection('users').doc(userCredential.user!.uid).set({}); instead of writing like this and
      //then adding various properties that I want to store I am creating a user model class to simplfy the process further
      UserModel userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No name',
          ProfilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: []);

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());//saving the data to our database

      print(userCredential.user?.email);
    } catch (e) {
      print(e);
    }
  }
}
