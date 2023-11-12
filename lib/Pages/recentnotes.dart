import 'package:flutter/material.dart';

class FastNoteApp extends StatelessWidget {
  const FastNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('FastNote'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'FastNote'),
                Tab(text: 'Recent Files'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              FastNotePage(),
              RecentFilesPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class FastNotePage extends StatefulWidget {
  const FastNotePage({super.key});

  @override
  _FastNotePageState createState() => _FastNotePageState();
}

class _FastNotePageState extends State<FastNotePage> {
  String uploadedText = '';

  void _summarizeText(String text) {
    // You can add your text summarization logic here
    setState(() {
      uploadedText = 'Summarized text: $text'; // Replace with actual summary
    });
  }

  Future<void> _uploadPdf() async {
    // You can implement the PDF file upload logic here
    // Use plugins like file_picker or pdf to handle PDF files
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _uploadPdf,
          child: const Text('Upload PDF'),
        ),
        const SizedBox(height: 20),
        Text('Uploaded Text: $uploadedText'),
      ],
    );
  }
}

class RecentFilesPage extends StatelessWidget {
  const RecentFilesPage({super.key});

  // This is where you can display the list of recently summarized files
  // You can use a ListView or any widget to display the files.

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Recent Files Page'),
    );
  }
}
