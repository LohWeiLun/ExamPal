
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../Models/category.dart';
import '../Widgets/category_card.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key:key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecf1f2),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xffecf1f2),
        color: Color(0xffc1e1e9),
        animationDuration: Duration(milliseconds: 300),
        onTap: (index){
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
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Melvin!',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '23 Jan, 2021',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),

                    Container(
                        decoration: BoxDecoration(
                          color: Color(0xffc1e1e9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.all(13),
                        child: Icon(
                          Icons.settings,
                          color: Colors.black87,
                        )
                    )
                  ],
                ),
                Body(),
              ],
            ),
          )

      ),
    );
  }
}

class Body extends StatelessWidget{
  const Body({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Services',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextButton(onPressed: () {}, child: Text('See All',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
              ))
            ],
          ),
        ),

        //Display Category Part

        GridView.builder(
          itemCount: categoryList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 24,
          ),
          itemBuilder: (context,index){
            return CategoryCard(
              category: categoryList[index],
            );

          },
        ),

      ],

    );
  }
}