import 'package:dartz/dartz.dart';
import 'package:moodhub/Data/models/auth/create_user.dart';
import 'package:moodhub/Data/models/auth/signin_user_req.dart';
import 'package:moodhub/Data/sources/auth/Firebase_authentication.dart';
import '../../../Domain/repositories/auth/Authenticate.dart';
import '../../../ServiceLocator.dart';
class auth_repository extends Authentication{
  @override
  Future<Either> Signin(SigninUserReq user) async{
    return await SL<AuthenticationFirebase>().Signin(user);
  }

  @override
  Future<Either> Signup(CreateUser user1) async{
    return await SL<AuthenticationFirebase>().Signup(user1);
  }
}