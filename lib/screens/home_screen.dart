import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'covertImageToPdf_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// CREATING VARIBALE TO STORE DIRECTORY PATH
  String downloadPath = "";

  /// CREATING THE file VARIABLE TO STORE ALL FILE PRESENT IN THE DIRECTORY
  List file = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// CALLING THIS METHOD TO GET ALL FILE OF THE DIRECTORY
    _listofFiles();
  }

  /// OpenPDF IS A METHOD TO OPEN PDF IN SYSTEM DEFAULT
  /// NOTE : THIS IS A PENDING TASK
  Future<void> OpenPDF(io.File file) async {
    print(file.path);
    try {
      // final String filePath = io.File(file);

      final Uri urL = Uri.file(file.path);

      if (await canLaunchUrl(urL)) {
        await launchUrl(urL);
      } else {
        throw 'Could not launch ${urL.path}';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// THIS METHOD IS USED TO GET ALL FILE FROM APPLICATION DIRECTORY AND SAVE IN LIST OF FILES VARIABLE
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
          file = io.Directory(downloadPath).listSync();
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
          file = io.Directory(downloadPath).listSync();
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
    /// _listofFiles THIS METHOD EVERY TIME TO GET THE LATEST FILES
    _listofFiles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        /// THIS IS FOR SEARCH BAR
        /// NOTE : THIS WORK IS ALSO PENDING
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(
                CupertinoIcons.search,
                color: Colors.grey,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Search",
                style: TextStyle(color: Colors.grey, fontSize: 17),
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/home.png"),
        )),
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            const Text(
              "Recent PDFs",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),

            /// LIST OF FILES IN THE DIRECTORY
            Expanded(
              child: ListView.builder(
                  itemCount: file.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // print("hello");
                        // OpenPDF(file[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.file_copy,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              file[index]
                                  .toString()
                                  .split("/")
                                  .last
                                  .replaceAll("'", ""),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),

            /// NAVIGATING TO THE SCREEN WHERE ALL MAGIC HAPPENED
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ConvertImageToPDFScreen()));
              },
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color(0xff2876F9),
                        Colors.cyan,
                      ])),
                  alignment: Alignment.center,
                  child: const Text(
                    "Convert Image to PDF",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
