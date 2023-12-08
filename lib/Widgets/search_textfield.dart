import 'package:flutter/material.dart';

import '../Constants/colors.dart';
import '../Pages/Login/page_search.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        showSearch(context: context, delegate: PageSearch());
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
          size: 26,
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        isDense: true,
      ),
    );
  }
}
