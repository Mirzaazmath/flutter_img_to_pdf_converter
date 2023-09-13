import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_img_to_pdf_converter/bloc/pdf_save_bloc/pdf_states.dart';


class SearchBloc extends Cubit<PDFStates>{
  SearchBloc():super(InitialPDFStatesState());

  void enterName(){
    emit(EnterNameState());
  }
  void processing(String name){
    emit(ProcessingState(name: name));
  }
   void savePDF(){
    emit(PDfSavedState());
   }

}