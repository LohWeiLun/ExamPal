import 'package:exampal/Pages/Voice-ToText/voicetotext.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VoiceToTextFunctionPage extends StatefulWidget {
  const VoiceToTextFunctionPage({Key? key});

  @override
  _VoiceToTextFunctionPageState createState() =>
      _VoiceToTextFunctionPageState();
}

class _VoiceToTextFunctionPageState extends State<VoiceToTextFunctionPage> {
  String? _selectedFileName;

  Future<void> _addMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'], // Allow only mp3 files
      );

      if (result != null) {
        final filePath = result.files.single.name;
        final fileType = result.files.single.extension;

        if (fileType == 'mp3') {
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
        title: const Text('Voice-To-Text'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/voiceToText.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '  Mp3 To Text',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attach Files',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: _addMedia,
                                  child: Icon(
                                    Icons.add,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            if (_selectedFileName != null)
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    'Selected File: $_selectedFileName',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '  Real-Time Voice Transcription',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/voiceLoading.png',
                            width: 100,
                            height: 100,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VoiceToTextPage(), // Replace VoiceToTextPage with your actual page
                                ),
                              );
                            },
                            child: const Text('Record Now'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
