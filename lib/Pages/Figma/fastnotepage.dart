import 'package:flutter/material.dart';

class FastNoteFunctionPage extends StatelessWidget {
  const FastNoteFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastNotePage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Recent Notes',
              style: TextStyle(
                color: Color(0xFF1F1F39),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            // Part 1: Display recent notes accessed by users
            // You can use a ListView or other widget to display the notes
            // Replace with your actual note list widget
            // Example: RecentNotesListWidget(),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Function to add media
                // You can open the camera or gallery for media selection
                // Add your media selection functionality here
              },
              child: const Text('Add Media'),
            ),

            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
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
            // Part 2: Function to create PDF documents
            // You can implement this functionality
            // Add your PDF creation functionality here
            // Example: ElevatedButton(onPressed: createPDF, child: Text('Create PDF')),

            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
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
            // Part 2: Function to summarize notes
            // You can implement this functionality
            // Add your note summarization functionality here
            // Example: ElevatedButton(onPressed: summarizeNotes, child: Text('Summarize Notes')),
          ],
        ),
      ),
    );
  }
}
