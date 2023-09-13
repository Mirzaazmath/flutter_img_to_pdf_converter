import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_img_to_pdf_converter/components/name_dailog.dart';
import 'package:flutter_img_to_pdf_converter/components/toast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../bloc/pdf_save_bloc/pdf_states.dart';
import '../bloc/pdf_save_bloc/save_bloc.dart';
import 'image_preview_screeen.dart';

class ConvertImageToPDFScreen extends StatefulWidget {
  const ConvertImageToPDFScreen({super.key});

  @override
  State<ConvertImageToPDFScreen> createState() =>
      _ConvertImageToPDFScreenState();
}

class _ConvertImageToPDFScreenState extends State<ConvertImageToPDFScreen> {
  /// CREATING THE VARIABLE TO STORE ALL IMAGES
  List<File>? images = [];

  /// CREATING THE INSTANCE FOR PACKAGE PDF
  final pdf = pw.Document();

  /// CREATING THE INSTANCE FOR CLASS TOAST
  final toast = AppToast();
  @override
  Widget build(BuildContext context) {
    /// USING BLOCCONSUMER FOR HANDLING THE STATE
    return BlocConsumer<SavePDfBloc, PDFStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Convert Image to PDF"),
            foregroundColor: Colors.blue,
            backgroundColor: Colors.white,
            elevation: 1,
            actions: [
              IconButton(
                  onPressed: () {
                    images!.isEmpty
                        ? toast.showToast("Please Add Images")
                        : context.read<SavePDfBloc>().enterName();
                  },
                  icon: const Icon(Icons.picture_as_pdf))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            /// _pickImage THIS IS USED TO COLLECT IMAGE FROM GALLERY
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
                child: images!.isEmpty
                    ? Image.asset("assets/addimage.png")
                    : const SizedBox(),
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
                                  /// FOR  IMAGE PREVIEW

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
                                  /// _removeImg THIS METHOD IS USED TO REMOVE THE IMAGE FROM LIST
                                  _removeImg(i);
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.6),
                                  child: const Icon(
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
      },

      /// BLOC LISTENER FOR HANDLING THE DAILOGS
      listener: (context, state) {
        if (state is EnterNameState) {
          /// TO SHOW THE NAME AND LOADING DAILOG
          _showNameDailog();
        } else if (state is ProcessingState) {
          /// TO CREATE AND SAVE THE PDF FROM IMAGES
          createPDF(state.name);
        } else if (state is PDfSavedState) {
          /// BACKING THE LOADER DIALOG

          Navigator.pop(context);

          /// SHOWING TOAST FOR SUCEESS
          toast.showToast("PDF Saved");

          /// CLEARING THE SCREEN AFTER PDF SAVE
          _clearScreen();
        }
      },
    );
  }

  /// CLEARING THE SCREEN AFTER PDF SAVE
  _clearScreen() {
    setState(() {
      images!.clear();
    });
  }

  /// TO SHOW THE NAME AND LOADING DAILOG
  _showNameDailog() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const CustomNameDialogBox();
        });
  }

  /// TO REMOVE THE IMAGE FROM LIST VIA INDEX
  void _removeImg(int index) {
    setState(() {
      images!.removeAt(index);
    });
  }

  /// PICKING THE IMAGES FROM GALLARY
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

  /// CREATE THE PDF USING THE PACKAGE PDF
  createPDF(String name) async {
    /// RUNNING THE LOOP FOR MULTIPLE IMAGES
    for (int i = 0; i < images!.length; i++) {
      /// THIS LINE HELP US TO CONVERT THEN IMAGE INTO PDF
      final image = pw.MemoryImage(images![i].readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image),
        ); // Center
      }));
    }

    /// CALL THE savePDF TO SAVE THE PDF IN MOBILE STORAGE
    await savePDF(name);
  }

  /// CALL THE savePDF TO SAVE THE PDF IN MOBILE STORAGE
  savePDF(String fileName) async {
    /// HERE IS THE PLATFORM SPECIFIC CODE
    /// FOR ANDROID
    try {
      if (Platform.isAndroid) {
        /// THIS IS THE PATH OF THE DIRECTORY FROM WHERE WE ARE GONNA SAVE ALL PDF
        var path = "/storage/emulated/0/Download/Flutter_imagetoPDF/";
        // Create the Downloads directory if it doesn't exist
        if (!await Directory(path).exists()) {
          await Directory(path).create(recursive: true);
        }

        /// CREATING THE FILE NAME WITH THE GIVEN NAME
        final file = File("$path/$fileName.pdf");
        debugPrint(file.toString());

        /// HERE WE ARE USING THE ISOLATE TO SAVE OUR PDF IN THE MOBILE STORAGE
        /// AND WE ARE PASING TWO THINGS PDF  AND FILE
        await IsolateFunc(pdf, file);
      }

      /// FOR IOS
      else {
        /// GETTING THE PATH FROM PACKAGE == PATH_PROVIDER
        final directory = await getApplicationDocumentsDirectory();

        final downloadPath = directory.path;

        // Create the Downloads directory if it doesn't exist
        if (!await Directory(downloadPath).exists()) {
          await Directory(downloadPath).create(recursive: true);
        }

        /// CREATING THE FILE NAME WITH THE GIVEN NAME
        final file = File("$downloadPath/$fileName.pdf");
        debugPrint(file.toString());

        /// HERE WE ARE USING THE ISOLATE TO SAVE OUR PDF IN THE MOBILE STORAGE
        /// AND WE ARE PASING TWO THINGS PDF  AND FILE
        await IsolateFunc(pdf, file);
      }

      /// CALLING THE savePDF FROM SavePDfBloc TO EMIT THE STATE
      context.read<SavePDfBloc>().savePDF();
    } catch (e) {
      /// PRINTING THE ERROR
      debugPrint("error while saving the pfd == $e");
    }
  }
}

/// THIS IS THE IsolateFunc TO HANDLE EXTRA WORK
/// THIS HELP US TO PREVENT THE SCREEN FREEZED
/// BECAUSE THE SAVE FILE IS TIME CONSUMING PROCESS
/// NOTE : ALWAYS CREATE THE ISOLATE OUTSIDE OF THE CLASS
/// MAKE IS SEPERATE
IsolateFunc(pdf, file) async {
  /// CREATING THE ReceivePort TO RECEVING THE SIGNAL FOR SENDER PORT
  final ReceivePort receivePort = ReceivePort();

  /// USING TRY CATCH
  try {
    /// TO USE ISOLATE import 'dart:isolate'; THIS LINE
    /// spawn METHOD IS USED TO CALL THE DIFFENT FUNCTIONS OR METHODS TO PERFROM OPERATION
    /// ON ANOTHER THREAD
    /// WE ARE ALSO PASSING OBJECT IN A LIST
    await Isolate.spawn(savePdfToFile, [receivePort.sendPort, pdf, file]);
  } on Object {
    /// EXCEPTION HANDLING
    debugPrint("Save File Isolate Failed");

    /// CLOSING THE receivePort
    receivePort.close();
  }

  /// WAIT FOR THE FUCTION TO EXCECUTE
  final res = await receivePort.first;
  debugPrint("value back from Isolate === $res");
}

/// SAVING THE PDF

savePdfToFile(List<dynamic> parameter) async {
  /// CREATING THE SendPort  AND ASSIGNING THE RECEVERPORT TO IT
  SendPort sendPort = parameter[0];
  final pdfBytes = await parameter[1].save();
  await parameter[2].writeAsBytes(pdfBytes);

  ///AFTER THE EXECUTION OF THE ALL THE FUNCTION
  /// WE ARE EXITING THE ISOLATE
  Isolate.exit(sendPort, true);
}
