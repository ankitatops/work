import 'package:flutter/material.dart';
import 'package:gridviewex/stackex.dart';

import 'cardex.dart';
import 'expandex.dart';

void main() {
  runApp(MaterialApp(home: ExpandedApp(),debugShowCheckedModeBanner: false,));
}

class Gridviewex extends StatefulWidget {
  const Gridviewex({super.key});

  @override
  State<Gridviewex> createState() => _GridviewexState();
}

class _GridviewexState extends State<Gridviewex> {
  List tech = [
    "Flutter",
    "Java",
    "Php",
    "Android",
    "Flutter",
    "Java",
    "Php",
    "Android",
  ];
  List techimg = [
    "https://img.icons8.com/color/512/flutter.png",
    "https://cdn3d.iconscout.com/3d/free/preview/free-java-3d-icon-png-download-7578017.png?f=webp&h=700",
    "https://study.com/cimages/videopreview/059tmsbnjx.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Android_robot.svg/1745px-Android_robot.svg.png",
    "https://img.icons8.com/color/512/flutter.png",
    "https://cdn3d.iconscout.com/3d/free/preview/free-java-3d-icon-png-download-7578017.png?f=webp&h=700",
    "https://study.com/cimages/videopreview/059tmsbnjx.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Android_robot.svg/1745px-Android_robot.svg.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: tech.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Center(
              child: Column(
                children: [
                  Image.network(techimg[index], width: 250, height: 150),
                  Text(tech[index]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
