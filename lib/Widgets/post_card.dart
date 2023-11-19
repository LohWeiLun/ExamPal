import 'package:exampal/Constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [Container(
          padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16
          ).copyWith(right:0),
          child: Row(
            children:[CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Gal_Gadot_at_the_2018_Comic-Con_International_13_%28cropped%29.jpg/1200px-Gal_Gadot_at_the_2018_Comic-Con_International_13_%28cropped%29.jpg'),
            ),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(
                    left: 8
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('username',style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          'Delete',
                        ].map((e) => InkWell(
                          onTap: () {
                            // Handle tap on the item here
                            // You can add your logic to perform an action when the item is tapped.
                            // For example, you can delete an item, close the dialog, or do something else.
                            // You can also identify the tapped item using its content, like 'Delete' in this case.
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: Text(e),
                          ),
                        )).toList(),
                      ),
                    ),
                  );
                }, icon: const Icon(Icons.more_vert),
              )
            ],
          ),
        ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.35,
            width: double.infinity,
            child: Image.network('https://plus.unsplash.com/premium_photo-1665657351427-efdfbf01fb81?q=80&w=1160&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              fit: BoxFit.cover,
            ),
          ),

          Row(
            children: [
              IconButton(onPressed: () {},icon:const Icon(Icons.favorite, color:Colors.red,)),
              IconButton(onPressed: () {},icon:const Icon(Icons.comment_outlined,color:Colors.black87)),
              IconButton(onPressed: () {},icon:const Icon(Icons.send,color:Colors.black87)),
              Expanded(child: Align(alignment: Alignment.bottomRight,child: IconButton(icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),),),
            ],
          ),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16,),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '1,231 likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: LightColors.kPrimaryColor),
                      children: [
                        TextSpan(
                          text: 'username',
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(
                          text: '  Description to be replaced',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('View all 200 comments', style: const TextStyle(
                    fontSize: 16,
                    color: LightColors.secondaryColor,
                  ),),
                ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('22/12/2023', style: const TextStyle(
                    fontSize: 16,
                    color: LightColors.secondaryColor,
                  ),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


