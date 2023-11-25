import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;


class PdfViewerPage extends StatefulWidget {
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final TextEditingController _pdfUrlController = TextEditingController();
  int _pageNumber = 1;
  int _totalPages = 0;
  late PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _pdfUrlController,
              decoration: InputDecoration(
                labelText: 'Enter PDF URL',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _loadPdf();
            },
            child: Text('Load PDF'),
          ),
          Expanded(
            child: PDFView(
              filePath: _pdfUrlController.text,
              onViewCreated: (PDFViewController pdfViewController) {
                setState(() {
                  _pdfViewController = pdfViewController;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_pageNumber > 1) {
                    _pageNumber--;
                    _pdfViewController.setPage(_pageNumber);
                  }
                },
                child: Text('Previous Page'),
              ),
              SizedBox(width: 16),
              Text('Page $_pageNumber of $_totalPages'),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (_pageNumber < _totalPages) {
                    _pageNumber++;
                    _pdfViewController.setPage(_pageNumber);
                  }
                },
                child: Text('Next Page'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _loadPdf() async {
    String pdfUrl = _pdfUrlController.text;

    if (pdfUrl.isNotEmpty) {
      // Replace this with your Python API endpoint
      String apiEndpoint = 'YOUR_PYTHON_API_ENDPOINT';

      // Make an API request to your Python API
      try {
        var response = await http.post(
          Uri.parse(apiEndpoint),
          body: {'pdf_url': pdfUrl},
        );

        // You can handle the API response here
        print('API Response: ${response.body}');
      } catch (e) {
        print('Error making API request: $e');
      }
    }
  }
}
