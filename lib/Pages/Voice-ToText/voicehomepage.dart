import 'package:exampal/Pages/Voice-ToText/voicetotext.dart';
import 'package:exampal/Pages/Voice-ToText/voicetotextpage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VoiceHomePage extends StatefulWidget {
  const VoiceHomePage({Key? key});

  @override
  _VoiceHomePageState createState() => _VoiceHomePageState();
}

class _VoiceHomePageState extends State<VoiceHomePage> {
  String? filePath; // Store the selected file path

  Future<void> _selectMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
      });
    }
  }

  void _navigateToVoiceToTextPage() {
    Navigator.push( // Navigating to VoiceToText page
      context,
      MaterialPageRoute(builder: (context) => VoiceToTextPage()),
    );
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
                        'Recordings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _selectMedia,
                        child: const Text('Add Media'),
                      ),
                    ],
                  ),
                ),

                // Container for Create PDF
                GestureDetector(
                  onTap: _navigateToVoiceToTextPage, // Navigating on tap
                  child: Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Real-Time Transcript',
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
                ),
              ],
            ),
            if (filePath != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Selected File: $filePath',textAlign: TextAlign.center,),
              ),
            const SizedBox(height: 20), // Spacer between rows
            // Container for Summarize Notes
            GestureDetector(
              onTap: _navigateToVoiceToTextPage, // Navigating on tap
              child: Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Convert Voice-To-Text',
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
            // Add functionality for summarizing notes here
          ],
        ),
      ),
    );
  }
}


