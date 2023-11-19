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
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // Add allowed extensions here
      );

      if (result != null) {
        final filePath = result.files.single.name;
        setState(() {
          _selectedFileName = filePath;
        });
        print('Selected file: $filePath');
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Row for RecentNotes & AddMedia, and Create PDF
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Container for Recent Notes & Add Media
                Container(
                  width: 200,
                  height: 300,
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
                      ElevatedButton(
                        onPressed: _addMedia, // Call the function here
                        child: const Text('Add Media'),
                      ),
                    ],
                  ),
                ),

                // Container for Create PDF
                Container(
                  width: 200,
                  height: 300,
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
                      // Add functionality for creating PDF here
                    ],
                  ),
                ),
              ],
            ),

            if (_selectedFileName != null) // Display the selected filename
              Text(
                'Selected File: $_selectedFileName',
                style: TextStyle(
                  color: Colors.black, // Adjust the color if needed
                  fontSize: 14, // Adjust the font size if needed
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),

            const SizedBox(height: 20), // Spacer between rows

            // Container for Summarize Notes
            Container(
              width: 350,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
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
            // Add functionality for summarizing notes here
          ],
        ),
      ),
    );
  }
}
