import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class stackex extends StatefulWidget {
  const stackex({super.key});

  @override
  State<stackex> createState() => _stackexState();
}

class _stackexState extends State<stackex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network("https://static.vecteezy.com/system/resources/previews/028/833/956/non_2x/three-bowls-with-colourful-candles-with-fireworks-in-the-background-diwali-stock-images-and-illustrations-photo.jpg"),
          Text("Happy Diwali",style: TextStyle(fontSize: 20,color: Colors.blue)),
        ],
      ),
    );
  }
}