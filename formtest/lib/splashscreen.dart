import 'dart:async';

import 'package:flutter/material.dart';
import 'form.dart';

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

    checkconnectivity();
    //Timer(Duration(seconds:3),() => Navigator.push(context,MaterialPageRoute(builder: (context) => FormEx())));

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      body: Center
        (

        child: Image.asset("assets/abcd.png"),
        //child:Lottie.asset('assets/animation.json'),
      ),
    );
  }

  checkconnectivity()async
  {
    var status = await Connectivity().checkConnectivity();

    if(status.contains(ConnectivityResult.wifi))
    {
      print("Wifi Connected");
    }
    else if(status.contains(ConnectivityResult.mobile))
    {
      print("Mobile Data Connected");
    }
    else
    {
      print("Network Error");
    }
  }
}


