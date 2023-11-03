import 'package:flutter/material.dart';

class RecentFilesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Files'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Recent Files',
              style: TextStyle(
                color: Color(0xFF1F1F39),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            // Part 1: Display recent files accessed by users (you can use a ListView or other widget)

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Function to add a new file
                // You can open a file picker or implement file upload functionality
              },
              child: Text('Add File'),
            ),
          ],
        ),
      ),
    );
  }
}
