import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget{
  var onPressed;
  var title;
  double? height;
  @override
  BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    super.key
  });
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(height?? 50),
          ),
          child: Text(title,style: TextStyle(color: Colors.white,fontSize: 25),)
      ),
    );
  }
  
}