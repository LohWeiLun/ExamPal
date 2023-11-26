import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  List<String> userFiles = [];

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
        title: Text('Fast Note Backup'),
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
                      height: 12,
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
                              userFiles.length > index ? userFiles[index] : "", // Display file numbers or custom names
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "File ${index + 1}",// Show filenames
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                //clickedToDownload
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: ((context, index) => Divider(
                          color: Colors.white,
                        )),
                        itemCount: userFiles.length,
                      ),
                    ),
                    SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "Functions",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 8),
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
                          onViewCreated: (PDFViewController pdfViewController) {
                            setState(() {
                              pdfReady = true;
                            });
                          },
                        ),
                      ),
                    SizedBox(height: 20,),
                    Text(
                      '  Notes Summarization',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child:  Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                CreatePDF(context),
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

  Widget CreatePDF(BuildContext context) {
    return Expanded(
      child: GestureDetector(onTap: () {
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
}
