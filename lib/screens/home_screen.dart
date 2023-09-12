import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'covertImageToPdf_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          height: 40,
          padding:const  EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child:const  Row(
            children: [
              Icon(CupertinoIcons.search,color: Colors.grey,),
              SizedBox(width: 20,),
              Text("Search",style: TextStyle(color: Colors.grey,fontSize: 17),)
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        height: double.infinity,
        width: double.infinity,
        decoration:const  BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/home.png"),
        )
      ),
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ConvertImageToPDFScreen()));
          },

          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient:const  LinearGradient(
                colors:[
                  Color(0xff2876F9),
                 Colors.cyan,

                ]
              )

            ),
            alignment: Alignment.center,
            child:const  Text("Convert Image to PDF",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
          ),
        ),
      ),



    );
  }
}
