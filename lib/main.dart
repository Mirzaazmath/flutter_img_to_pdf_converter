import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_img_to_pdf_converter/bloc/pdf_save_bloc/save_bloc.dart';
import 'package:flutter_img_to_pdf_converter/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// MultiBlocProvider FOR STATE MANGEMNET
    return MultiBlocProvider(
      providers: [
        /// PASSING THE BLOC TO ENTIRE APP
        BlocProvider(
          create: (context) => SavePDfBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,

        /// HOMESCREEN
        home: HomeScreen(),
      ),
    );
  }
}
