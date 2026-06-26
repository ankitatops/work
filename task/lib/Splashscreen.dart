import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task/FormEx.dart';

class Splashscreen extends StatefulWidget
{
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
{

  @override
  void initState()
  {

    Timer(Duration(seconds:2),() => Navigator.push(context,MaterialPageRoute(builder: (context) => FormEx())));

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      body: Center
        (

        child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4Z_6ze3WQeIErmppDKSILtai6OZl7wZw8xA&s.jpg"),
      ),
    );
  }
}
