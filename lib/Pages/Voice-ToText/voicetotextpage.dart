import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VoiceToText extends StatefulWidget {
  const VoiceToText({Key? key}) : super(key: key);

  @override
  _VoiceToTextState createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  String? _selectedFileName;

  Future<void> _addMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['audio'], // Add allowed audio extensions here
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
        title: const Text('Voice-To-Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Convert voice to text',
              style: TextStyle(
                color: Color(0xFF1F1F39),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMedia,
              child: const Text('Add Media'),
            ),
            const SizedBox(height: 20),
            // Container for Record
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Record',
                  style: TextStyle(
                    color: Color(0xFF1F1F39),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Container for Upload a File
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Upload a File',
                  style: TextStyle(
                    color: Color(0xFF1F1F39),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
