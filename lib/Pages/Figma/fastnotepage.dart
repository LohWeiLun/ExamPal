import 'package:flutter/material.dart';

class FastNotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FastNotePage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Recent Notes',
              style: TextStyle(
                color: Color(0xFF1F1F39),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            // Part 1: Display recent notes accessed by users (you can use a ListView or other widget)
            // Replace with your actual note list widget

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Function to add media
                // You can open the camera or gallery for media selection
                // Add your media selection functionality here
              },
              child: Text('Add Media'),
            ),

            SizedBox(height: 20),
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Create PDF',
                  style: TextStyle(
                    color: Color(0xFF1F1F39),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            // Part 2: Function to create PDF documents (you can implement this functionality)
            // Add your PDF creation functionality here

            SizedBox(height: 20),
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Summarize Notes',
                  style: TextStyle(
                    color: Color(0xFF1F1F39),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            // Part 2: Function to summarize notes (you can implement this functionality)
            // Add your note summarization functionality here
          ],
        ),
      ),
    );
  }
}
