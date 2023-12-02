import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';

class PdfTextEditorPage extends StatefulWidget {
  final String title;

  const PdfTextEditorPage({Key? key, required this.title}) : super(key: key);

  @override
  _PdfTextEditorPageState createState() => _PdfTextEditorPageState();
}

class _PdfTextEditorPageState extends State<PdfTextEditorPage> {
  late PdfDocument document;

  Future<void> _loadDocument(String filePath) async {
    try {
      final File file = File(filePath);
      if (file.existsSync()) {
        final Uint8List bytes = await file.readAsBytes();
        document = PdfDocument(inputBytes: bytes);
      } else {
        print('File does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> _extractText() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        String filePath = result.files.first.path!;
        await _loadDocument(filePath);

        if (document != null) {
          PdfTextExtractor extractor = PdfTextExtractor(document);
          String text = extractor.extractText();
          _showResult(text);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showResult(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Extracted text'),
              IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Text copied to clipboard')),
                  );
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              text,
              textAlign: TextAlign.left,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text(
                'Select PDF',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _extractText,
            )
          ],
        ),
      ),
    );
  }
}
