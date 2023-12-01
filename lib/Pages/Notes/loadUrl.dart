import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl; // Add a constructor to receive the PDF URL

  PdfViewerPage({required this.pdfUrl}); // Constructor

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PDFDocument document;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPdfDocument();
  }

  Future<void> loadPdfDocument() async {
    final PDFDocument loadedDocument =
    await PDFDocument.fromURL(widget.pdfUrl); // Access URL from widget
    setState(() {
      document = loadedDocument;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator
            : PDFViewer(document: document), // Display the loaded document
      ),
    );
  }
}
