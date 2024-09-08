import 'package:dartz/dartz.dart';
import 'package:moodhub/Data/models/auth/signin_user_req.dart';
import 'package:moodhub/Domain/repositories/auth/Authenticate.dart';

import '../../../Core/usecases/usecase.dart';
import '../../../ServiceLocator.dart';

class SigninUseCase implements UseCase<Either,SigninUserReq>{
  @override
  Future<Either> call({SigninUserReq ? params}) async{
    return SL<Authentication>().Signin(params!);
  }

}