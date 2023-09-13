/// ALL STATE TO SAVE PDF

abstract class PDFStates {}

class InitialPDFStatesState extends PDFStates {}

class EnterNameState extends PDFStates {}

class ProcessingState extends PDFStates {
  final String name;
  ProcessingState({required this.name});
}

class PDfSavedState extends PDFStates {}
