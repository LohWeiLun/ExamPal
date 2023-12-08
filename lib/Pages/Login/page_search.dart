import 'package:flutter/material.dart';

import '../Figma/testFastNote.dart';
import '../FileConversion/FileConversionPage.dart';
import '../Timetable/schedule_mainpage.dart';
import '../Voice-ToText/voiceToTextFunction.dart';

class PageSearch extends SearchDelegate<String> {
  final List<String> pages = ['Schedule', 'Fast Note', 'Voice to Text', 'File Conversion'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement your logic for search results here
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? pages
        : pages.where((page) => page.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            navigateToPage(context, suggestionList[index]);
          },
        );
      },
    );
  }

  void navigateToPage(BuildContext context, String selectedPage) {
    switch (selectedPage) {
      case 'Schedule':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SchedulePage()));
        break;
      case 'Fast Note':
        Navigator.push(context, MaterialPageRoute(builder: (context) => FastNoteBackupFunctionPage()));
        break;
      case 'Voice to Text':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const VoiceToTextFunctionPage()));
        break;
      case 'File Conversion':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FileConversionFunctionPage()));
        break;
      default:
      // Handle unknown page
    }
  }
}
