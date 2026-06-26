
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThirdScreen extends StatefulWidget
{
  @override
  ThirdState createState() => ThirdState();

}

class ThirdState extends State<ThirdScreen>
{
  bool _isHappy = true;

  @override
  Widget build(BuildContext context)
  {
    return Column
      (
      children:
      [
        Text("Current Mood: ",style: TextStyle(fontSize: 20.00),),
        Text(
          _isHappy ? '😊 Happy' : '😔 Sad',
          style: TextStyle(fontSize: 24),
        ),
        TextButton(onPressed: ()
        {
          setState(()
          {
            _isHappy = !_isHappy;
          });
        }, child: Text("Chnage Mood"))

      ],
    );
  }

}
