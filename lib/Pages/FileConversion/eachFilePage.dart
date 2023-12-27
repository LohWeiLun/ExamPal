import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:path/path.dart';

class EachFileConvertPage extends StatefulWidget {
  final String? selectedTitle;
  const EachFileConvertPage({Key? key, this.selectedTitle}) : super(key: key);

  @override
  _EachFileConvertPageState createState() => _EachFileConvertPageState();
}

class _EachFileConvertPageState extends State<EachFileConvertPage> {
  late BuildContext dialogContext;
  String? _selectedFileName;
  String _selectedFilePath = "";
  late String _iconPath = 'assets/icons/pdf.png'; // Default icon path
  bool isConverting = false;

  final url = 'http://192.168.159.175:5000/upload_and_convert';

  Future<void> _sendToAPI() async {
    var apiUrl = Uri.parse(url);
    if (_selectedFilePath != null) {
      var file = File(_selectedFilePath);

      print("Sending file from this path " + _selectedFilePath);
      if (file != null) {
        var request = http.MultipartRequest('POST', apiUrl);

        var fileStream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'file',
          fileStream,
          length,
          filename: file.path.split("/").last,
        );

        request.files.add(multipartFile);

        try {
          var response = await request.send();

          if (response.statusCode == 200) {
            String responseBody = await response.stream.bytesToString();
            Map<String, dynamic> jsonResponse = json.decode(responseBody);

            if (jsonResponse.containsKey('converted_file_url')) {
              var convertedFileUrl = jsonResponse['converted_file_url'];
              var fileResponse = await http.get(Uri.parse(convertedFileUrl));

              String? downloadsDirectoryPath =
                  (await DownloadsPath.downloadsDirectory())?.path ?? "";
              var fileName = basename(_selectedFilePath);
              downloadsDirectoryPath += "/$fileName.pdf";

              await File(downloadsDirectoryPath)
                  .writeAsBytes(fileResponse.bodyBytes);

              print("Successfully Download the File");

              showDialog(
                context: dialogContext,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Success'),
                    content: Text('File Converted successfully!'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          } else {
            print("Something wrong with the API");
          }
        } catch (e) {
          print('Error during file upload: $e');
        }
      }
    }
  }

  Future<void> _addMedia() async {
    try {
      List<String>? allowedExtensions;
      String defaultIcon = 'assets/icons/pdf.png'; // Default icon for other file types

      switch (widget.selectedTitle) {
        case 'Merge PDF':
        case 'Split PDF':
        case 'PDF to JPG':
        case 'JPG to PDF':
          allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
          _iconPath = 'assets/icons/pdf.png';
          break;
        case 'Word to PDF':
          allowedExtensions = ['doc', 'docx'];
          _iconPath = 'assets/office/word.png';
          defaultIcon = 'assets/office/word.png';
          break;
        case 'PowerPoint to PDF':
          allowedExtensions = ['ppt', 'pptx'];
          _iconPath = 'assets/office/pp.png';
          defaultIcon = 'assets/office/pp.png';
          break;
        case 'Excel to PDF':
          allowedExtensions = ['xls', 'xlsx'];
          _iconPath = 'assets/office/excel.png';
          defaultIcon = 'assets/office/excel.png';
          break;
        default:
          allowedExtensions = null;
          break;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        final filePath = result.files.single.name;
        final actualPath = result.files.single.path ?? "";
        final fileType = result.files.single.extension;

        if (allowedExtensions == null || allowedExtensions.contains(fileType)) {
          setState(() {
            _selectedFileName = filePath;
            _selectedFilePath = actualPath;
            _iconPath = fileType != null ? defaultIcon : 'assets/icons/pdf.png';
          });
          print('Selected file: $filePath');
          print('Selected Path : $actualPath');
        } else {
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
    dialogContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedTitle ?? "Functions"),
        backgroundColor: Colors.purpleAccent.withOpacity(0.35),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fileConversion.jpg'),
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
                      '  Attach Files',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 0),
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.withOpacity(0.35),
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
                                child: _selectedFileName != null
                                    ? Image.asset(
                                  _iconPath,
                                  width: 120,
                                  height: 120,
                                )
                                    : InkWell(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Selected File: $_selectedFileName',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        _selectedFileName = null;
                                        _selectedFilePath = "";
                                        _iconPath = 'assets/icons/pdf.png';
                                      });
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isConverting = true; // Show loading indicator
                  });
                  await _sendToAPI(); // Perform conversion
                  setState(() {
                    isConverting = false; // Hide loading indicator after conversion
                  });
                },
                child: isConverting
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ) // Show white circular progress indicator when converting
                    : Text('Convert File'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

