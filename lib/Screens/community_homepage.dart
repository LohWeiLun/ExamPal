import 'package:flutter/material.dart';

class CommunityHomepage extends StatefulWidget {
  const CommunityHomepage({super.key});

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
        actions: const [
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
                            const SizedBox(height: 10),
                            const Text(
                              "Profile Name",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            )
                          ],
                        ),
                      )),
            ),
          ),
          const Divider(),
          Column(
            children: List.generate(
              1,
              (index) => Column(
                children: [
                  //HEADER POST
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
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
                      const Text("Profile Name"),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
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
