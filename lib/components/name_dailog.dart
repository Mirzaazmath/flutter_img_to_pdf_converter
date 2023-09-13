import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_img_to_pdf_converter/bloc/pdf_save_bloc/pdf_states.dart';
import 'package:flutter_img_to_pdf_converter/bloc/pdf_save_bloc/save_bloc.dart';

// CUSTOM DAILOG CLASS
class CustomNameDialogBox extends StatefulWidget {
  const CustomNameDialogBox();

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomNameDialogBox> {
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavePDfBloc, PDFStates>(builder: (context, state) {
      if (state is ProcessingState) {
        // THIS DAILOG IS FOR LOADING
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.padding),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: loadingcontentBox(context));
      }
      // THIS DAILOG IS FOR NAMING
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
                      "Enter Name",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                                offset: const Offset(2, 2),
                                blurRadius: 2),
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(-2, -2),
                                blurRadius: 2)
                          ]),
                      child: TextFormField(
                        controller: _nameController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                            hintText: "Enter File Name",
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<SavePDfBloc>()
                              .processing(_nameController.text);
                        },
                        child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(colors: [
                                  Color(0xff2876F9),
                                  Colors.cyan,
                                ])),
                            alignment: Alignment.center,
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ),
                    )
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
                    backgroundColor: Colors.blue,
                    radius: 50,
                    child: Icon(
                      Icons.note_add_outlined,
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

  loadingcontentBox(context) {
    return Stack(
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
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 150,
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 6,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Processing..")
                  ],
                ),
              )
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
              backgroundColor: Colors.blue,
              radius: 50,
              child: Icon(
                Icons.sync,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
