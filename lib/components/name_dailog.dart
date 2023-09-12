import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';


// CUSTOM DAILOG CLASS
class CustomDialogBox extends StatefulWidget {



  const CustomDialogBox();

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){

    return Stack(
      children: <Widget>[
        Container(
          padding: const  EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin:const  EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow:const  [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("hello",style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color:Colors.green,),),
              const   SizedBox(height: 15,),
              Text("dcsdc",style:  TextStyle(fontSize: 14,color:Colors.green,),textAlign: TextAlign.center,),
              const SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomRight,
                child:GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepPurpleAccent
                      ),
                      alignment: Alignment.center,
                      child: Text("efvef",style:const  TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                ),

              )
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: CircleAvatar(
              backgroundColor:Colors.green,
              radius: 50,child: Icon( Icons.check_circle_outline_outlined,size: 60,color: Colors.white,),
            ),

          ),
        ),
      ],
    );
  }
}
class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}