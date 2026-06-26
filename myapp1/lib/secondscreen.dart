
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget
{
  @override
  SecondState createState() => SecondState();
}
class SecondState extends State<SecondScreen>
{
  int count = 0;

  @override
  Widget build(BuildContext context)
  {
    return Column
      (
      children:
      [
        Text("Likes : $count"),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: ()
        {
          setState(()
          {
            count++;
          });

          //print(count);

        }, child: Text("Like"))

      ],
    );
  }

}
