import 'package:get_it/get_it.dart';
import 'package:moodhub/Data/repositories/auth/Auth_Repository.dart';
import 'package:moodhub/Data/repositories/songs_auth/Songs.dart';
import 'package:moodhub/Data/sources/auth/Firebase_authentication.dart';
import 'package:moodhub/Domain/repositories/auth/Authenticate.dart';
import 'package:moodhub/Domain/usecases/auth/Signup.dart';


import 'Domain/usecases/auth/signin.dart';

final SL=GetIt.instance;

Future<void> initializeDependencies() async{
  SL.registerSingleton<AuthenticationFirebase>(
    Authentication_firebase()
  );

  SL.registerSingleton<Authentication>(
      auth_repository()
  );
  SL.registerSingleton<SignupUseCase>(
      SignupUseCase()
  );
  SL.registerSingleton<SigninUseCase>(
      SigninUseCase()
  );



}