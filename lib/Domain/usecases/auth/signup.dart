import 'package:dartz/dartz.dart';
import 'package:moodhub/Data/models/auth/create_user.dart';
import 'package:moodhub/Domain/repositories/auth/Authenticate.dart';

import '../../../Core/usecases/usecase.dart';
import '../../../ServiceLocator.dart';

class SignupUseCase implements UseCase<Either,CreateUser>{
  @override
  Future<Either> call({CreateUser ? params}) async{
    return SL<Authentication>().Signup(params!);
  }

}