import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_img_to_pdf_converter/components/loading_dailog.dart';
import 'package:flutter_img_to_pdf_converter/components/name_dailog.dart';
import 'package:flutter_img_to_pdf_converter/components/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List<File>? images = [];
  final pdf = pw.Document();
  final toast = AppToast();
  @override
  Widget build(BuildContext context) {
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
                    context.read<SavePDfBloc>().enterName();
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
                                  backgroundColor:
                                      Colors.white.withOpacity(0.6),
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
      },
      listener: (context, state) {
        if (state is EnterNameState) {
          _showNameDailog();
        } else if (state is ProcessingState) {
          // _showLoaderDailog();
          createPDF(state.name);
          // await savePDF(state.name);
        } else if (state is PDfSavedState) {
          Navigator.pop(context);
          toast.showToast("Hello World");

          // do Something
        }
      },
    );
  }

  _showNameDailog() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const CustomNameDialogBox();
        });
  }

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
  createPDF(String name) async {
    for (int i = 0; i < images!.length; i++) {
      final image = pw.MemoryImage(images![i].readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image),
        ); // Center
      }));
    }
    await savePDF(name);
  }

  savePDF(String fileName) async {
    try {
      if (Platform.isAndroid) {
        var path = "/storage/emulated/0/Download";
        final file = File("$path/$fileName.pdf");
        debugPrint(file.toString());
        //await savePdfToFile(pdf, file);
        await IsolateFunc(pdf,file);
        //await file.writeAsBytes(await pdf.save());
      } else {
        final directory = await getApplicationDocumentsDirectory();
        //  final directory = await getDownloadsDirectory();
        final downloadPath = directory.path;

// Create the Downloads directory if it doesn't exist
        if (!await Directory(downloadPath).exists()) {
          await Directory(downloadPath).create(recursive: true);
        }
        final file = File("$downloadPath/$fileName.pdf");
        debugPrint(file.toString());
        await IsolateFunc(pdf,file);
       // await savePdfToFile(pdf, file);
        //await file.writeAsBytes(await pdf.save());
      }
      context.read<SavePDfBloc>().savePDF();
    } catch (e) {
      debugPrint("error while saving the pfd == $e");
    }
  }


}

IsolateFunc(pdf,file)async{
  final ReceivePort receivePort=ReceivePort();
  try{
    await Isolate.spawn(savePdfToFile,[receivePort.sendPort,pdf, file] );
  }on Object{
    debugPrint("Save File Isolate Failed");
    receivePort.close();
  }
final res = await receivePort.first;
  debugPrint("value back from Isolate === $res");
}



savePdfToFile(List<dynamic> parameter) async{
  SendPort  sendPort= parameter[0];
  final pdfBytes = await parameter[1].save();
  await parameter[2].writeAsBytes(pdfBytes);
  Isolate.exit(sendPort,true);

}


