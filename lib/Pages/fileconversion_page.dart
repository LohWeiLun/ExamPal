import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileConversionPage extends StatefulWidget {
  @override
  _FileConversionPageState createState() => _FileConversionPageState();
}

class _FileConversionPageState extends State<FileConversionPage> {
  final _formKey = GlobalKey<FormState>();
  File? _file; // Declare _file as nullable
  String? _convertedFilePath; // Declare _convertedFilePath as nullable

  Future<void> _pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles();

    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.files.single.path!);
      });
    }
  }

  Future<void> _convertFile(String fileType) async {
    if (_formKey.currentState!.validate()) {
      // Get the temp directory
      final directory = await getTemporaryDirectory();

      if (_file != null) {
        // Define the new file extension based on the selected file type
        final newExtension = fileType == 'pdf' ? 'pdf' : 'docx'; // You can add more extensions

        // Generate a new file path with the selected extension
        final newFilePath = '${directory.path}/converted_file.$newExtension';

        // Simulate conversion by copying the file to the new path
        await _file!.copy(newFilePath);

        // Update the state with the converted file path
        setState(() {
          _convertedFilePath = newFilePath;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Conversion'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Choose File: '),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text('Pick File'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Selected File: '),
                  Text(_file != null ? _file!.path : 'No file selected'),
                ],
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Select File Type'),
                items: <String>['pdf', 'docx'] // Add more file types as needed
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a file type';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    // Convert the file
                    _convertFile(newValue);
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Converted File: '),
                  Text(
                    _convertedFilePath != null ? _convertedFilePath! : 'No file converted',
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
