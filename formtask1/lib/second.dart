

import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget
{
  final String userName;

  const SecondScreen({super.key,required this.userName});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: Text("Welcome ${widget.userName}"),),
      body: Center(
        child: Text(
          "Hello, ${widget.userName}! 🎉",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
