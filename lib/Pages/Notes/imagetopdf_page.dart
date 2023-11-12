/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';



class ImageToPdf extends StatefulWidget {
  const ImageToPdf({super.key});

  @override
  _ImageToPdfState createState() => _ImageToPdfState();
}

class _ImageToPdfState extends State<ImageToPdf> {
  final _picker = ImagePicker();
  final List<File> _imageFiles = [];

  Future<void> _convertToPdf() async {
    final pdf = pw.Document();

    for (var imageFile in _imageFiles) {
      final image = pw.MemoryImage(File(imageFile.path).readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(child: pw.Image(image));
      }));
    }

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());

    print('PDF saved to ${file.path}');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to PDF Converter'),
      ),
      body: Container(
        color: const Color(0xffc1e1e9), // Background color
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFiles.isNotEmpty
                ? Column(
              children: _imageFiles.map((file) {
                return Card(
                  elevation: 4, // Add elevation for a card-like effect
                  child: Image.file(file),
                );
              }).toList(),
            )
                : const Text('No image selected'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _convertToPdf,
              child: const Text('Convert to PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
*/