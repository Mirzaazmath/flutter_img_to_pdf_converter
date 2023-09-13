import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';


// CUSTOM DAILOG CLASS
class CustomLoadingDialogBox extends StatefulWidget {



  const CustomLoadingDialogBox();

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomLoadingDialogBox> {
  TextEditingController _nameController=TextEditingController();



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }
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
              Container(
                height: 150,
                alignment: Alignment.center,
                child:const  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 6,
                    ),
                    SizedBox(height: 30,),
                    Text("Processing..")
                  ],
                ),
              )



            ],
          ),
        ),
       const  Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: CircleAvatar(
              backgroundColor:Colors.blue,
              radius: 50,child: Icon( Icons.sync,size: 50,color: Colors.white,),
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