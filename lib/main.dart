import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:moodhub/Core/Configs/Theme/App_theme.dart';
import 'package:moodhub/ServiceLocator.dart';
import 'package:moodhub/firebase_options.dart';
import 'package:moodhub/presentation/ChooseMode/bloc/Theme_cubit.dart';
import 'package:moodhub/presentation/SplashScreen/pages/Splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> main() async{
  Gemini.init(apiKey: 'AIzaSyB4ahHheNLoaHeGdlJPs_-OeTYOIW2_zeA');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>ThemeCubit())
      ],
      child: BlocBuilder<ThemeCubit,ThemeMode>(
        builder: (context,mode)=>MaterialApp(
          theme: App_Theme.lightTheme,
          darkTheme: App_Theme.darkTheme,
          themeMode: mode,
          home: SplashScreen()
        ),
      ),
    );
  }
}
