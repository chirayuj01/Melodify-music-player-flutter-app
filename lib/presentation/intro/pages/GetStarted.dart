import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodhub/Core/Configs/Theme/App_colors.dart';
import 'package:moodhub/common/widgets/Buttons/Basic_app_button.dart';
import 'package:moodhub/presentation/ChooseMode/pages/Choosemode.dart';

class GetStartedPage extends StatefulWidget{
  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/jair-medina-nossa.jpg'),


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
              SizedBox(height: 470,),
              Text('Enjoy listening to Music',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Satoshi',

                    fontSize: 27,
                    fontWeight: FontWeight.w800

                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: 330,
                height: 120,
                child: Center(child: Text("Immerse yourself in a world of music with endless playlists and genres. Discover, listen, and enjoy your favorite tunes anywhere.",textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      color: App_Colors.grey.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Satoshi'
                  ),
                )
                ),
              ),
              SizedBox(height: 20,),
              BasicAppButton(onPressed: (){
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Choose_Mode(),
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

              }, title: 'Get Started',height: 60,)
            ],
          )

        ],
      ),
    );
  }
}