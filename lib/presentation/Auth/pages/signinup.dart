import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodhub/Core/Configs/Theme/App_colors.dart';
import 'package:moodhub/common/widgets/Buttons/Basic_app_button.dart';
import 'package:moodhub/presentation/Auth/pages/Signin.dart';
import 'package:moodhub/presentation/Auth/pages/Signup.dart';

class Sign_up_in extends StatefulWidget{
  @override
  State<Sign_up_in> createState() => _Sign_up_inState();
}

class _Sign_up_inState extends State<Sign_up_in> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness==Brightness.light?App_Colors.lightbackground:Colors.black,
        ),
        body: Column(
          children: [
            SizedBox(height: 230,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo_melodify.png',height: 60,width: 70,color: App_Colors.primary,),
                Text('Melodify',style: TextStyle(
                    color: App_Colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    decoration: TextDecoration.none
                ),)
              ],
            ),
            SizedBox(height: 15,),
            Text('Enjoy listening to music',style: TextStyle(
              color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 15,),
            Container(
              height: 80,
              width: 330,
              child: Text("Melodify: Your gateway to personalized music, endless playlists, and seamless enjoyment.",textAlign: TextAlign.center,style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 17
              ),),

            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => Signup_page(),
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
                  }, child: Center(
                    child: Text('Register',style: TextStyle(
                      fontSize: 22,
                      color: Colors.white
                    ),),
                  )),
                ),
                SizedBox(width: 50,),
                TextButton(onPressed: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => Signin_page(),
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
                }, child: Text('Sign in',style: TextStyle(
                    fontSize: 22,

                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                )
                ),
              ],
            )
          ],
        ),
      );
  }
}