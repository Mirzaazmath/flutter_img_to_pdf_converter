

import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

import '../components/name_dailog.dart';
class RecentPdfSCreen extends StatefulWidget {

   RecentPdfSCreen({super.key,});

  @override
  State<RecentPdfSCreen> createState() => _RecentPdfSCreenState();
}


class _RecentPdfSCreenState extends State<RecentPdfSCreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();
  }
  /// CREATING VARIBALE TO STORE DIRECTORY PATH
  String downloadPath = "";

  /// CREATING THE file VARIABLE TO STORE ALL FILE PRESENT IN THE DIRECTORY
  List files = [];


  void _listofFiles() async {
    /// USING TRY CATCH
    try {
      /// HERE IS THE PLATFORM SPECIFIC CODE
      /// FOR ANDROID
      if (io.Platform.isAndroid) {
        /// THIS IS THE PATH OF THE DIRECTORY FROM WHERE WE ARE GONNA GET ALL FILE

        downloadPath = "/storage/emulated/0/Download/Flutter_imagetoPDF/";

        /// CHECKING THE DIRECTORY IS EXISTS OR NOT
        if (!await io.Directory(downloadPath).exists()) {
          // IF NOT THEN WE ARE CREATING ONE
          await io.Directory(downloadPath).create(recursive: true);
        }

        /// SETTING ALL FILE FROM THE DIRECTORY IN A  LIST  VARIABLE
        setState(() {
          files = io.Directory(downloadPath).listSync();
          //use your folder name insted of resume.
        });
      }

      /// FOR IOS

      else {
        /// GETTING THE PATH FROM PACKAGE == PATH_PROVIDER
        final directory = await getApplicationDocumentsDirectory();

        /// SETTING THE PATH IN A VARIBLE
        downloadPath = directory.path;

        // Create the Downloads directory if it doesn't exist
        if (!await io.Directory(downloadPath).exists()) {
          await io.Directory(downloadPath).create(recursive: true);
        }

        /// SETTING ALL FILE FROM THE DIRECTORY IN A  LIST  VARIABLE
        setState(() {
          files = io.Directory(downloadPath).listSync();
          //use your folder name insted of resume.
        });
      }
    } catch (e) {
      /// PRINTING THE ERROR IF ANY
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //_listofFiles();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recent PDFs"),
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
            itemCount:files.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // print("hello");
                  // OpenPDF(file[index]);
                },
                child: Container(
                  margin:const  EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10)
                ),
                  padding: const EdgeInsets.all(10),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.file_copy,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        files[index]
                            .toString()
                            .split("/")
                            .last
                            .replaceAll("'", ""),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                     const  Spacer(),
                      GestureDetector(
                        onTap: (){
                          _showDeleteDailog(context,files[index]);

                        },
                          child:const  Icon(Icons.delete,color: Colors.red,))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
  /// DIALOG FROM DELETE FILE
  _showDeleteDailog(context,deletefile) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.padding),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: Constants.padding,
                        top: Constants.avatarRadius + Constants.padding,
                        right: Constants.padding,
                        bottom: Constants.padding),
                    margin: const EdgeInsets.only(top: Constants.avatarRadius),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Constants.padding),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 10),
                              blurRadius: 10),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          "Do you want to Delete this File ?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                   border: Border.all( color: Colors.red,)
                                  ),
                                  alignment: Alignment.center,
                                  child:const  Text("No",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                           const  SizedBox(width: 50,),
                            Expanded(
                              child: GestureDetector(
                                onTap: ()async{
                                 await deleteFile(deletefile);
                                 Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      border: Border.all( color: Colors.red,)
                                  ),
                                  alignment: Alignment.center,
                                  child:const  Text("Yes",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),


                          ],
                        ),


                      ],
                    ),
                  ),
                  const Positioned(
                    left: Constants.padding,
                    right: Constants.padding,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: Constants.avatarRadius,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 50,
                        child: Icon(
                          Icons.error,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }
  deleteFile(io.File file) async{
try{
  await file.delete();
  _listofFiles();
     }catch(e){
  debugPrint(e.toString());
    }
    }

}
