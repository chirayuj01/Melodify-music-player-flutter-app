import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodhub/Data/models/auth/create_user.dart';
import 'package:moodhub/Data/models/auth/signin_user_req.dart';
abstract class AuthenticationFirebase{
  Future<Either> Signin(SigninUserReq user);
  Future<Either> Signup(CreateUser user);

}
class Authentication_firebase extends AuthenticationFirebase{
  @override
  Future<Either> Signin(SigninUserReq user) async{
    String emailAddress=user.email;
    String password=user.password;
    try {
      var data=await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );

      return Right('Signin was successful');
    } on FirebaseAuthException catch (e) {
      var message="";
      if (e.code == 'user-not-found') {
        message='No user found for that email.';
      } else if (e.code == 'wrong-password') {
       message='Wrong password provided for that user.';
      }
      return left(message);
    }

  }

  @override
  Future<Either> Signup(CreateUser user) async{
    String emailAddress=user.Email;
    String password=user.Password;
    try {
      var data=await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      FirebaseFirestore.instance.collection('users').add(
          {
            'name':user.fullname,
            'email':data.user?.email
          }
      );
      return Right('Signup successful');

    } on FirebaseAuthException catch (e) {
      var message="";
      if (e.code == 'weak-password') {
        message='The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message='The account already exists for that email.';
      }
      return left(message);
    }
  }

}