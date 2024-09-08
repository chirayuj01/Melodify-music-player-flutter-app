import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodhub/presentation/Auth/pages/signinup.dart';
import 'package:moodhub/presentation/ChooseMode/bloc/Theme_cubit.dart';

import '../../../Core/Configs/Theme/App_colors.dart';
import '../../../common/widgets/Buttons/Basic_app_button.dart';

class Choose_Mode extends StatefulWidget{
  @override
  State<Choose_Mode> createState() => _Choose_ModeState();
}

class _Choose_ModeState extends State<Choose_Mode> {
  var darkop=0.3;
  var lightop=0.3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/ibrahim-rifath.jpg'),


                )
            ),

          ),
          Container(
            color: App_Colors.Darkbackground.withOpacity(0.6),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo_melodify.png',height: 60,width: 65,color: App_Colors.primary,),
                  Text('Melodify',style: TextStyle(
                      fontFamily: 'Satoshi',

                      color: App_Colors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      decoration: TextDecoration.none
                  ),)
                ],
              ),
              SizedBox(height: 400,),
              const Text('Choose Mode',style: TextStyle(
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 28
              ),),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          context.read<ThemeCubit>().UpdateTheme(ThemeMode.dark);
                          print('key pressed');
                          darkop=1.0;
                          lightop=0.3;
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 40,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black.withOpacity(darkop),
                          child: const Icon(Icons.nightlight_outlined,size: 35,),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text('Dark Mode',style: TextStyle(
                        color: App_Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Satoshi',
                      ),)
                    ],
                  ),
                  const SizedBox(width: 80,),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          context.read<ThemeCubit>().UpdateTheme(ThemeMode.light);
                          lightop=1.0;
                          darkop=0.3;
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 40,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black.withOpacity(lightop),
                          child: const Icon(Icons.light_mode_outlined,size: 40,),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text('Light Mode',style: TextStyle(
                        color: App_Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Satoshi',
                      ),)
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 60,),
              BasicAppButton(onPressed: (){
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Sign_up_in(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      // Slide from right to left
                      const beginOffset = Offset(1.0, 0.0);
                      const endOffset = Offset.zero;
                      var slideTween = Tween(begin: beginOffset, end: endOffset);
                      var slideAnimation = animation.drive(slideTween);

                      // Scale effect
                      var scaleTween = Tween<double>(begin: 0.8, end: 1.0);
                      var scaleAnimation = animation.drive(CurveTween(curve: Curves.easeOutBack).chain(CurveTween(curve: Curves.easeInOut)));

                      return SlideTransition(
                        position: slideAnimation,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              }, title: 'Continue',height: 60,)
              

            ],
          )

        ],
      ),
    );
  }
}