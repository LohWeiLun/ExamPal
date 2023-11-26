import 'package:exampal/Pages/Voice-ToText/voicetotext.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class eachFileConvertPage extends StatefulWidget {
  final String? selectedTitle; // Add selectedTitle property

  const eachFileConvertPage({Key? key, this.selectedTitle}) : super(key: key);

  @override
  _eachFileConvertPageState createState() => _eachFileConvertPageState();
}

class _eachFileConvertPageState extends State<eachFileConvertPage> {
  String? _selectedFileName;



  Future<void> _addMedia() async {
    try {
      List<String>? allowedExtensions;

      // Determine allowed file extensions based on selectedTitle
      switch (widget.selectedTitle) {
        case 'Merge PDF':
        case 'Split PDF':
        case 'PDF to JPG':
        case 'JPG to PDF':
          allowedExtensions = ['pdf', 'jpg', 'jpeg'];
          break;
        case 'Word to PDF':
          allowedExtensions = ['doc', 'docx'];
          break;
        case 'PowerPoint to PDF':
          allowedExtensions = ['ppt', 'pptx'];
          break;
        case 'Excel to PDF':
          allowedExtensions = ['xls', 'xlsx'];
          break;
        default:
        // If the selected title doesn't match any specific case, allow all file types
          allowedExtensions = null;
          break;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        final filePath = result.files.single.name;
        final fileType = result.files.single.extension;

        if (allowedExtensions == null || allowedExtensions.contains(fileType)) {
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
        title: Text(widget.selectedTitle ?? "Functions"),
        backgroundColor: Colors.purpleAccent.withOpacity(0.35),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fileConversion.jpg'), // Replace with your image path
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
                      height: 180, // Adjust the height as needed
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
            ],
          ),
        ),
      ),
    );
  }
}
