import 'dart:convert';
import 'dart:io';

import 'package:exampal/Pages/Figma/chatPDF.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import '../ChatGPT/chat_screen.dart';
import '../Notes/loadUrl.dart';

class FastNoteBackupFunctionPage extends StatefulWidget {
  @override
  _FastNoteBackupFunctionPageState createState() =>
      _FastNoteBackupFunctionPageState();
}

class _FastNoteBackupFunctionPageState
    extends State<FastNoteBackupFunctionPage> {
  bool isUrlInputVisible = false;
  TextEditingController urlController = TextEditingController();
  String? pdfUrl;
  int pageNumber = 0;
  bool pdfReady = false;

  String? _selectedFileName;
  String _selectedFilePath = "";
  late String _iconPath = 'assets/icons/pdf.png';

  List<String> userFiles = [];
  String? additionalText = " ";

  bool isSummarizing = false;

  final url = 'http://192.168.68.104:5000/upload_pdf';

  @override
  void initState() {
    super.initState();
    // Call the function to fetch and display user files when the widget initializes
    displayUserFiles();
  }

  Future<void> displayUserFiles() async {
    // Replace 'post' with the childName where your files are stored for the user
    String childName = '/post';
    Reference ref = FirebaseStorage.instance.ref().child(childName);

    try {
      ListResult result = await ref.listAll();
      // Get filenames for each item and add them to the userFiles list
      for (Reference reference in result.items) {
        String filename = reference.name; // Fetch the filename
        userFiles.add(filename);
      }
      // Update the UI after fetching the filenames
      setState(() {});
    } catch (e) {
      print('Error fetching user files: $e');
      // Handle errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fast Note'),
        elevation: 0,
        backgroundColor: Colors.amber,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fastnoteback.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Files",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.asset('assets/icons/pdf.png'),
                            title: Text(
                              userFiles.length > index
                                  ? userFiles[index]
                                  : "", // Display file numbers or custom names
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "File ${index + 1}", // Show filenames
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            // trailing: IconButton(
                            //   onPressed: () {
                            //     //clickedToDownload
                            //   },
                            //   icon: const Icon(
                            //     Icons.cancel,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          );
                        },
                        separatorBuilder: ((context, index) => Divider(
                          color: Colors.white,
                        )),
                        itemCount: userFiles.length,
                      ),
                    ),
                    SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          "Functions",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 5),
                        isUrlInputVisible
                            ? UrlInputContainer(context)
                            : OriginalFunctionsContainer(context),
                      ],
                    ),
                    if (pdfUrl != null && pdfReady)
                      Expanded(
                        child: PDFView(
                          filePath: pdfUrl!,
                          onError: (error) {
                            print('Error occurred: $error');
                          },
                          onPageChanged: (int? page, int? total) {
                            setState(() {
                              pageNumber = page ?? 0;
                            });
                          },
                          onViewCreated:
                              (PDFViewController pdfViewController) {
                            setState(() {
                              pdfReady = true;
                            });
                          },
                        ),
                      ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        Text(
                          "Notes Summarization",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '  Attach Files',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: _selectedFileName != null
                                    ? Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              _iconPath,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ],
                                        ),
                                        if (_selectedFileName != null)
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Selected File: $_selectedFileName',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                    fontWeight:
                                                    FontWeight.w400,
                                                  ),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.cancel),
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedFileName =
                                                      null;
                                                      _selectedFilePath =
                                                      "";
                                                      _iconPath =
                                                      'assets/icons/pdf.png';
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (!isSummarizing)
                                      ElevatedButton(
                                        onPressed: summarizeNotes,
                                        child: Text('Summarize'),
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Source_id: ${additionalText ?? "N/A"}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                                    : InkWell(
                                  onTap: addMedia,
                                  child: Icon(
                                    Icons.add,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (isSummarizing)
                                Center(
                                  child: CircularProgressIndicator(),
                                ), // Loading indicator
                            ],
                          ),
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
    );
  }

  void viewPdfFromUrl(String url) async {
    // Navigate to PDF Viewer page and pass the URL
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(pdfUrl: url),
      ),
    );
  }

  Widget OriginalFunctionsContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            child: Row(
              children: [
                LoadURL(context),
                const SizedBox(width: 12),
                ChatGPT(context),
              ],
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget UrlInputContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          BackButton(
            onPressed: () {
              setState(() {
                isUrlInputVisible = false;
              });
            },
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: "Enter URL",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              viewPdfFromUrl(urlController.text);
              print('Entered URL: ${urlController.text}');
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
    );
  }

  Widget LoadURL(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isUrlInputVisible = true;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/icons/hyperlink.png',
                width: 350,
                height: 60,
              ),
              Text(
                'Load URL',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ChatGPT(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigate to ChatScreen when the container is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/icons/chatgpt.png',
                width: 350,
                height: 60,
              ),
              Text(
                'ChatGPT',
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> summarizeNotes() async {
    if (_selectedFilePath.isNotEmpty) {
      setState(() {
        isSummarizing = true; // Set the flag to true when summarization starts
      });

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.68.104:5000/upload_pdf'));
      request.files.add(
          await http.MultipartFile.fromPath('pdf_file', _selectedFilePath));

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var parsedData = json.decode(responseData);

          var sourceId = parsedData['Source ID'];
          setState(() {
            additionalText = sourceId.toString();
            isSummarizing = false; // Set the flag to false after summarization is done
          });

          // Navigate to ChatPDF page after sourceId is generated
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatPDFPage(sourceId: sourceId.toString())),
          );
        } else {
          // Handle other status codes if needed
        }
      } catch (error) {
        print('Error: $error');
        // Handle errors here
        setState(() {
          isSummarizing = false; // Reset the flag in case of an error
        });
      }
    } else {
      // Handle case when no file is selected
    }
  }

  Future<void> addMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      await uploadFileToStorage(file);

      setState(() {
        _selectedFileName = file.path.split('/').last;
        _selectedFilePath = file.path;
        // You may want to update _iconPath based on the file type
        _iconPath = 'assets/icons/pdf.png';
      });
    }
  }

  Future<void> uploadFileToStorage(File file) async {
    try {
      // Replace 'post' with the childName where you want to store the file
      String childName = '/post/${file.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(childName);

      await ref.putFile(file);

      // Refresh the list of user files after uploading
      await displayUserFiles();
    } catch (e) {
      print('Error uploading file: $e');
      // Handle errors here
    }
  }
}
