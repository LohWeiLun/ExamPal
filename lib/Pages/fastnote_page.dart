import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Widgets/custom_icon_button.dart';

class FastNotePage extends StatefulWidget {
  const FastNotePage({Key? key}) : super(key: key);

  @override
  _FastNotePageState createState() => _FastNotePageState();
}

class _FastNotePageState extends State<FastNotePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xffecf1f2),
          color: Color(0xffc1e1e9),
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            print(index);
          },
          items: [
            Icon(
              Icons.group,
              color: Colors.black87,
            ),
            Icon(
              Icons.add,
              color: Colors.black87,
            ),
            Icon(
              Icons.person,
              color: Colors.black87,
            ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconButton(
                      child: const Icon(Icons.arrow_back),
                      height: 35,
                      width: 35,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fast Note',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            color: Colors.green,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Recent Notes",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  height: size.height * 0.3,
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: ((context, index) {
                                      return ListTile(
                                        leading: Image.asset('assets/images/pdf.png'),
                                        title: Text(
                                          "Filename",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Path To File",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.cancel, color: Colors.white),
                                        ),
                                      );
                                    }),
                                    separatorBuilder: ((context, index) => Divider(color: Colors.white)),
                                    itemCount: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.12,
                                  child: Row(
                                    children: [
                                      buttonWidget(
                                        color: Colors.blue,
                                        onTap: () {},
                                        path: "assets/images/internet.png",
                                        title: "Create PDF",
                                      ),
                                      const SizedBox(width: 12),
                                      buttonWidget(
                                        color: Colors.blue,
                                        onTap: () {},
                                        path: "assets/images/pdf_file.png",
                                        title: "Select File",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                buttonWidget(
                                  color: Colors.blue,
                                  onTap: () {},
                                  path: "assets/images/pdf_file.png",
                                  title: "Create PDF",
                                ),
                              ],
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
        ),
      ),
    );
  }

  Widget buttonWidget({color, path, title, onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("$path", width: 45),
              Text(
                "$title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}