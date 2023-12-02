import 'package:exampal/Pages/Voice-ToText/voicetotext.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../OCR/imageToText.dart';
import 'eachFilePage.dart';

class FileConversionFunctionPage extends StatefulWidget {
  const FileConversionFunctionPage({Key? key});

  @override
  _FileConversionFunctionPageState createState() =>
      _FileConversionFunctionPageState();
}

class _FileConversionFunctionPageState extends State<FileConversionFunctionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Converter'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/images/fileConversion.jpg'),
        fit: BoxFit.cover,
       ),
      ),
      child: ListView(
        children: [
          // Merge PDF
          // _buildListTile(
          //   title: 'Merge PDF',
          //   subtitle: 'Combine multiple PDF files into a single PDF file.',
          //   iconPath: 'assets/conversionIcons/merge.png',
          //   onTap: () {},
          // ),
          // Split PDF
          // _buildListTile(
          //   title: 'Split PDF',
          //   subtitle: 'Split a single PDF file into multiple PDF files.',
          //   iconPath: 'assets/conversionIcons/split.png',
          //   onTap: () {},
          // ),
          // Word to PDF
          _buildListTile(
            title: 'Word to PDF',
            subtitle: 'Convert a Word document to a PDF file.',
            iconPath: 'assets/conversionIcons/word.png',
            onTap: () {},
          ),
          // PowerPoint to PDF
          _buildListTile(
            title: 'PowerPoint to PDF',
            subtitle: 'Convert a PowerPoint presentation to a PDF file.',
            iconPath: 'assets/conversionIcons/powerpoint.png',
            onTap: () {},
          ),
          // Excel to PDF
          _buildListTile(
            title: 'Excel to PDF',
            subtitle: 'Convert an Excel spreadsheet to a PDF file.',
            iconPath: 'assets/conversionIcons/excel.png',
            onTap: () {},
          ),
          // PDF to JPG
          // _buildListTile(
          //   title: 'PDF to JPG',
          //   subtitle: 'Convert a PDF file to a JPG image.',
          //   iconPath: 'assets/conversionIcons/pdfTojpg.png',
          //   onTap: () {},
          // ),
          // JPG to PDF
          _buildListTile(
            title: 'JPG to PDF',
            subtitle: 'Convert a JPG image to a PDF file.',
            iconPath: 'assets/conversionIcons/jpgToPdf.png',
            onTap: () {},
          ),
        ],
      ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to ImageToTextPage when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageToTextPage(), // Replace with your ImageToTextPage
            ),
          );
        },
        child: Icon(Icons.camera_alt), // Use any camera icon you prefer
        backgroundColor: Colors.blue, // Customize the button color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      child: SizedBox(
        height: 90.0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 18.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black.withOpacity(0.5),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
            leading: Padding(
              padding: EdgeInsets.only(left: 10.0), // Adjust left padding here
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EachFileConvertPage(
                    selectedTitle: title, // Pass the selected title
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}