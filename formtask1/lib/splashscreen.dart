import 'dart:async';

import 'package:flutter/material.dart';
import 'package:formtask1/main.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 5),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FormEx()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSINANtZr7y31NQ8vA3EaYenIlZcS08_q5k-vuSSdpXiGXKxqRDN690L6RdqnoyKILAkI&usqp=CAU.jpg"),
        //child:Lottie.asset('assets/animation.json'),
      ),
    );
  }
}
