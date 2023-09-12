import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
//import '../components/name_dailog.dart';
import 'image_preview_screeen.dart';

class ConvertImageToPDFScreen extends StatefulWidget {
  const ConvertImageToPDFScreen({super.key});

  @override
  State<ConvertImageToPDFScreen> createState() =>
      _ConvertImageToPDFScreenState();
}

class _ConvertImageToPDFScreenState extends State<ConvertImageToPDFScreen> {
  List<File>? images = [];
  final pdf = pw.Document();
  //String fileName="";
  TextEditingController _nameController=TextEditingController();
  bool isload=false;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Convert Image to PDF"),
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
              onPressed: (){
             showNameDialog(context);
            },

              icon: const Icon(Icons.picture_as_pdf))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [
                Color(0xff2876F9),
                Colors.cyan,
              ])),
          child: const Icon(
            CupertinoIcons.add,
            size: 30,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            height: double.infinity,
            width: double.infinity,
            child: Image.asset("assets/addimage.png"),
          ),
          images == []
              ? const SizedBox()
              : GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    for (int i = 0; i < images!.length; i++) ...[
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ImagePreviewScreen(
                                        image: images![i],
                                      )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: FileImage(images![i]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _removeImg(i);
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white.withOpacity(0.6),
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ]
                  ],
                )
        ],
      ),
    );
  }
  void showNameDialog(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                        Text("Enter Name",style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color:Colors.blue,),),
                        const   SizedBox(height: 15,),
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    offset:const  Offset(2,2),
                                    blurRadius: 2),
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    offset: const Offset(-2,-2),
                                    blurRadius: 2)]
                          ),


                          child: TextFormField(

                            controller: _nameController,
                            maxLines: 1,
                            decoration:const  InputDecoration(
                                hintText: "Enter File Name",
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        const SizedBox(height: 22,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child:GestureDetector(
                            onTap: (){

                               // fileName=_nameController.text;




                              covertingProcess(_nameController.text);

                            },
                            child: Container(
                                height: 40,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient:const  LinearGradient(
                                        colors:[
                                          Color(0xff2876F9),
                                          Colors.cyan,

                                        ]
                                    )
                                ),
                                alignment: Alignment.center,
                                child:const Text("Save",style:  TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)),
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
                        backgroundColor:Colors.blue,
                        radius: 50,child: Icon( Icons.note_add_outlined,size: 50,color: Colors.white,),
                      ),

                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }



  covertingProcess(String  name){



    if(name==""){

    }
    else{
      createPDF();
      savePDF(name);
      Navigator.of(context).pop();
    }

  }

  ///
  void _removeImg(int index) {
    setState(() {
      images!.removeAt(index);
    });
  }

  ///
  Future _pickImage() async {
    try {
      final List? image = await ImagePicker().pickMultiImage();

      if (image?.length == 0) return;
      final List<File> imageTemp = image!.map((e) => File(e.path)).toList();
      setState(() => this.images!.addAll(imageTemp));
      print(image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  ///
  createPDF() async {
    for (int i=0;i<images!.length;i++){
      final image = pw.MemoryImage(images![i].readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image),
        ); // Center
      }));

    }

  }

  savePDF(String fileName) async {
    try {
      if(Platform.isAndroid){
      var path="/storage/emulated/0/Download";
      final file = File("$path/$fileName.pdf");
      debugPrint(file.toString());
         await file.writeAsBytes(await pdf.save());
      }else{

        final directory  =  await  getApplicationDocumentsDirectory();
      //  final directory = await getDownloadsDirectory();
        final downloadPath = directory.path;

// Create the Downloads directory if it doesn't exist
        if (!await Directory(downloadPath).exists()) {
          await Directory(downloadPath).create(recursive: true);
        }
      final file = File("$downloadPath/$fileName.pdf");
        debugPrint(file.toString());
        await file.writeAsBytes(await pdf.save());


      }

      showToast();
    } catch (e) {
      debugPrint("error while saving the pfd == $e");
    }
  }

  showToast() {
    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}