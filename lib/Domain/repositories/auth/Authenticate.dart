import 'package:dartz/dartz.dart';
import 'package:moodhub/Data/models/auth/create_user.dart';
import 'package:moodhub/Data/models/auth/signin_user_req.dart';

abstract class Authentication{
  Future<Either> Signin(SigninUserReq user);
  Future<Either> Signup(CreateUser user);

}