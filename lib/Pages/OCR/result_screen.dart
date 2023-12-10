import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  Future<void> _generateAndPrintPDF(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(text),
        );
      },
    ));

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'result.pdf');
  }

  Future<void> _generateAndOpenPDF(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(text),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/result.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    if (await file.exists()) {
      OpenFile.open(file.path);
    }
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Result'),
      actions: [
        IconButton(
          onPressed: () => _generateAndOpenPDF(context),
          icon: Icon(Icons.picture_as_pdf),
        ),
        IconButton(
          onPressed: () => _generateAndPrintPDF(context),
          icon: Icon(Icons.share),
        ),
      ],
    ),
    body: Container(
      padding: const EdgeInsets.all(30.0),
      child: Text(text),
    ),
  );
}