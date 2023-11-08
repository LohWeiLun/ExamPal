import 'package:flutter/material.dart';

class CommunityHomepage extends StatefulWidget {
  @override
  _CommunityHomepageState createState() => _CommunityHomepageState();
}

class _CommunityHomepageState extends State<CommunityHomepage> {
  List<String> profileImages = [
    "assets/images/clock.png",
    // Add more image paths here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo/exampalLogo.png",
          height: 50,
        ),
        actions: [
          SizedBox(
            width: 50, // Add your desired spacing between icons here
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 50, // Add your desired spacing between icons here
            child: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 50, // Add your desired spacing between icons here
            child: Icon(
              Icons.chat_bubble_outline,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  1,
                  (index) => Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage(
                                profileImages[index], //story
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: AssetImage(
                                  profileImages[index],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Profile Name",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            )
                          ],
                        ),
                      )),
            ),
          ),
          Divider(),
          Column(
            children: List.generate(
              1,
              (index) => Column(
                children: [
                  //HEADER POST
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundImage: AssetImage(
                            profileImages[index], //images/story
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundImage: AssetImage(
                              profileImages[index],
                            ),
                          ),
                        ),
                      ),
                      Text("Profile Name"),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {},
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}