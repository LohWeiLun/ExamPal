import 'dart:convert';
import 'package:exampal/Pages/Voice-ToText/voicetotext.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class VoiceToTextFunctionPage extends StatefulWidget {
  const VoiceToTextFunctionPage({Key? key}) : super(key: key);

  @override
  _VoiceToTextFunctionPageState createState() =>
      _VoiceToTextFunctionPageState();
}

class _VoiceToTextFunctionPageState extends State<VoiceToTextFunctionPage> {
  String? _selectedFileName;
  String? _convertedText;
  late String _filePath;
  bool _isConverting = false;

  Future<void> _convertAudioToText(String filePath) async {
    setState(() {
      _isConverting = true;
    });

    var url = 'http://192.168.68.103:5000/upload';
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        setState(() {
          _convertedText = responseBody;
          _isConverting = false;
        });
        print('Text from server: $responseBody');
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          _isConverting = false;
        });
      }
    } catch (e) {
      print('Error sending request: $e');
      setState(() {
        _isConverting = false;
      });
    }
  }

  Future<void> _addMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'], // Allow only mp3 files
      );

      if (result != null) {
        _filePath = result.files.single.path!;
        final fileName = path.basename(_filePath);
        final fileType = result.files.single.extension;

        if (fileType == 'mp3') {
          setState(() {
            _selectedFileName = fileName;
          });
          print('Selected file: $fileName');
        } else {
          print('Unsupported file type selected');
          return;
        }
      } else {
        print('User canceled the file picker');
        return;
      }
    } catch (e) {
      print('Error selecting file: $e');
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice-To-Text'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/voiceToText.png'),
              fit: BoxFit.cover,
            ),
          ),
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
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_selectedFileName != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/mp3.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
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
                                        IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: _clearSelection,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            if (_selectedFileName != null && !_isConverting)
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isConverting = true; // Set to true when "Convert Now" is pressed
                                  });
                                  await _convertAudioToText(_filePath);
                                },
                                child: Text('Convert Now'),
                              ),
                            if (_isConverting)
                              CircularProgressIndicator(), // Show only when converting
                            if (_selectedFileName == null)
                              InkWell(
                                onTap: () async {
                                  await _addMedia();
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '  Converted Text',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Container(
                    height: 300, // Adjust the height as needed
                    width: 250, // Adjust the width as needed
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _convertedText ?? 'Converted text will appear here',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
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
                                    builder: (context) => VoiceToTextPage()),
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
              SizedBox(height: 12),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: [
              //     Text(
              //       '  Text To Speech',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 18,
              //         fontFamily: 'Poppins',
              //       ),
              //     ),
              //     SizedBox(
              //       height: 200,
              //       child: Container(
              //         decoration: BoxDecoration(
              //           color: Colors.lightBlue[100],
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         child: Center(
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 // Existing content...
              //                 Container(
              //                   padding: EdgeInsets.symmetric(horizontal: 20),
              //                   child: TextField(
              //                     maxLines: 5,
              //                     decoration: InputDecoration(
              //                       border: OutlineInputBorder(),
              //                       hintText: 'Enter text here...',
              //                     ),
              //                     onChanged: (value) {
              //                       // Do something with the entered text
              //                     },
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
