

import 'package:flutter/material.dart';

class FirstScreen1 extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Container
      (
      color: Colors.blue.shade50,
      padding: EdgeInsets.all(16.0),
      child: Row
        (
        children:
        [
          CircleAvatar(backgroundImage: NetworkImage("https://png.pngtree.com/png-vector/20230831/ourmid/pngtree-man-avatar-image-for-profile-png-image_9197908.png"),radius: 40,),
         // CircleAvatar(backgroundImage: AssetImage("abcd.png"),radius: 40),
          SizedBox(width: 20,),
          Column
            (
            children:
            [
              Text("Flutter Developer",style: TextStyle(fontSize: 20.00),),
              Text("Tops Technologies")

            ],
          )

        ],
      ),


    );
  }

}
