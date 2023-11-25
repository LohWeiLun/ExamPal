import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFLoader extends StatefulWidget {
  @override
  _PDFLoaderState createState() => _PDFLoaderState();
}

class _PDFLoaderState extends State<PDFLoader> {
  String url = "https://www.volstate.edu/sites/default/files/documents/humanities/english/Best-Essays-2014-2015.pdf";
  late ValueNotifier<PDFDocument> _doc;
  late ValueNotifier<bool> _loading;

  @override
  void initState() {
    super.initState();
    _doc = ValueNotifier<PDFDocument>(PDFDocument());
    _loading = ValueNotifier<bool>(true);
    _initPdf();
  }


  _initPdf() async {
    try {
      final doc = await PDFDocument.fromURL(url);
      _doc.value = doc;
      _loading.value = false;
    } catch (error) {
      print("Error loading PDF: $error");
      // Handle the error, show an error message, or perform other actions.
    }
  }

  @override
  void dispose() {
    _doc.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _loading,
      builder: (context, loading, _) {
        return loading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ValueListenableBuilder(
          valueListenable: _doc,
          builder: (context, doc, _) {
            return PDFViewer(
              document: doc,
              indicatorBackground: Colors.red,
              // showIndicator: false,
              // showPicker: false,
            );
          },
        );
      },
    );
  }
}

