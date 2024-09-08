import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moodhub/Data/models/auth/signin_user_req.dart';
import 'package:moodhub/common/widgets/Buttons/Basic_app_button.dart';
import 'package:moodhub/presentation/Auth/pages/Signup.dart';

import '../../../Core/Configs/Theme/App_colors.dart';
import '../../../Domain/usecases/auth/signin.dart';
import '../../../ServiceLocator.dart';
import '../../root/pages/root.dart';

class Signin_page extends StatefulWidget{
  @override
  State<Signin_page> createState() => _Signin_pageState();
}

class _Signin_pageState extends State<Signin_page> {
  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  bool isloading=false;
  final formkey=GlobalKey<FormState>();
  bool pass=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness==Brightness.light?App_Colors.lightbackground:Colors.black,
        title:  Row(

          children: [
            SizedBox(width: 60,),
            Image.asset('assets/images/logo_melodify.png',height: 40,width: 40,color: App_Colors.primary,),
            Text('Melodify',style: TextStyle(
                fontFamily: 'Satoshi',

                color: App_Colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                decoration: TextDecoration.none
            ),)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 65,),
            Center(
              child: Text('Sign in',textAlign: TextAlign.center,style: TextStyle(
                  color: Theme.of(context).brightness==Brightness.dark?App_Colors.lightbackground:Colors.black,
                  fontSize: 38,
                  fontWeight: FontWeight.bold
              ),),
            ),
            Form(
              key: formkey,
              child: Padding(
                padding: EdgeInsets.only(left: 30,right: 30,top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      TextFormField(
                        validator: (value){
                          if(value==''){
                            return "Field cannot be empty";
                          }
                          if(!value.toString().contains('@')){
                            return "invalid email id";
                          }
                        },
                        controller: username,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: ' Email',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: App_Colors.Darkgrey,
                                    width: 3


                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: App_Colors.Darkgrey,


                                )
                            )
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: password,
                        validator: (value){
                          if(value!.length<8){
                            return "Password should contain atleast 8 characters";
                          }
                        },
                        obscuringCharacter: '*',
                        obscureText: !pass,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(

                            hintText: ' Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                pass=!pass;
                                setState(() {});
                              },
                              child: pass == false
                                  ? Icon(

                                Icons.remove_red_eye_outlined,
                                color: App_Colors.grey,
                              )
                                  : Padding(
                                padding: const EdgeInsets.only(top: 16.0,left: 12),
                                child: FaIcon(
                                  FontAwesomeIcons.eyeSlash,
                                  size: 19,
                                  color: App_Colors.grey,
                                ),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: App_Colors.Darkgrey,
                                    width: 3


                                )
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: App_Colors.Darkgrey,


                                )
                            )
                        ),
                      ),
                      SizedBox(height: 50,),
                      isloading?CircularProgressIndicator(
                        color: App_Colors.primary,
                        strokeCap: StrokeCap.square,
                      ):BasicAppButton(onPressed: ()async{
                        if(formkey.currentState!.validate()){
                          formkey.currentState!.save();

                          setState(() {
                            isloading=true;
                          });
                          var result=await SL<SigninUseCase>().call(
                              params: SigninUserReq(
                                  email: username.text.toString(),
                                  password: password.text.toString()
                              )
                          );
                          result.fold(
                                  (l){
                                    setState(() {
                                      isloading=false;
                                    });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(behavior: SnackBarBehavior.floating,backgroundColor:Colors.red,width:350,content: Text('wrong credentials or Network error',style: TextStyle(color: Colors.white),)));
                              },
                                  (r){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(behavior: SnackBarBehavior.floating,backgroundColor:App_Colors.primary,content: Text('Account login successfull',style: TextStyle(color: Colors.white),)));

                                    Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context)=>RootPage(username.text.toString())),
                                        (route) => false
                                );
                              }
                          );

                        }

                      }, title: 'Sign in',height: 60,),
                      SizedBox(height: 40,),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1, // Thickness of the line
                              color: Colors.grey, // Color of the line
                              indent: 20, // Left indent
                              endIndent: 10, // Right indent before text
                            ),
                          ),
                          Text(
                            'Or',
                            style: TextStyle(color: Colors.grey), // Text style
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                              indent: 10, // Right indent after text
                              endIndent: 20, // Right indent
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account? ',style: TextStyle(
                            color: Theme.of(context).brightness==Brightness.dark?App_Colors.grey:Colors.black.withOpacity(0.6)
                          ),),
                          GestureDetector(onTap: (){
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
                          }, child: Text('Register',style: TextStyle(color: App_Colors.primary),))
                        ],
                      )


                    ],
                  ),
                ),
              ),

            )
          ],
        ),
      ),
    );
  }
}