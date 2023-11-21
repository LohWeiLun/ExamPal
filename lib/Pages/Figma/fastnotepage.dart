import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FastNoteFunctionPage extends StatefulWidget {
  const FastNoteFunctionPage({Key? key});

  @override
  _FastNoteFunctionPageState createState() => _FastNoteFunctionPageState();
}

class _FastNoteFunctionPageState extends State<FastNoteFunctionPage> {
  String? _selectedFileName;

  Future<void> _addMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'], // Allow PDF and Google Docs (doc/docx)
      );

      if (result != null) {
        final filePath = result.files.single.name;
        final fileType = result.files.single.extension;

        if (fileType == 'pdf' || fileType == 'doc' || fileType == 'docx') {
          setState(() {
            _selectedFileName = filePath;
          });
          print('Selected file: $filePath');
        } else {
          // Handle unsupported file type selected
          print('Unsupported file type selected');
        }
      } else {
        print('User canceled the file picker');
      }
    } catch (e) {
      print('Error selecting file: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastNotePage'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4), // Added padding
                    child: Container(
                      width: 100, // Adjust container width
                      height: 200, // Adjust container height
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Recent Notes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset(
                            'assets/icons/pdf.png', // Replace with your image path
                            width: 100, // Adjust width as needed
                            height: 100, // Adjust height as needed
                          ),
                          ElevatedButton(
                            onPressed: _addMedia,
                            child: const Text('Add Media'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4), // Added padding
                    child: Container(
                      width: 100, // Adjust container width
                      height: 200, // Adjust container height
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Create PDF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset(
                            'assets/icons/pdf.png', // Replace with your image path
                            width: 100, // Adjust width as needed
                            height: 100, // Adjust height as needed
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Generate PDF'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (_selectedFileName != null) // Display the selected filename
              Padding(
                padding: EdgeInsets.only(top: 10), // Add padding only at the top
                child: Center(
                  child: Text(
                    'Selected File: $_selectedFileName',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center, // Align the text center
                  ),
                ),
              ),
            const SizedBox(height: 10), // Spacer between rows

            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Summarize Notes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}