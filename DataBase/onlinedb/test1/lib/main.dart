import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mymodel.dart';

void main()
{
  runApp(MaterialApp(home:ViewData(),debugShowCheckedModeBanner: false,));
}
class ViewData extends StatefulWidget
{
  const ViewData({super.key});

  @override
  State<ViewData> createState() => _ViState();
}

class _ViState extends State<ViewData> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        appBar: AppBar(title: Text("View Details"),),
        body: FutureBuilder
          (
          future: getdata(),
          builder: (context, snapshot)
          {
            if(snapshot.hasError)
            {
              print("No Data Found");
            }
            else if (snapshot.hasData)
            {

              return MyModel(list:snapshot.data);
            }

            return CircularProgressIndicator();
          },


        )

    );
  }

  getdata() async
  {
    var url = Uri.parse("https://simplifiedcoding.net/demos/marvel/");
    var res = await http.get(url);
    return jsonDecode(res.body);
  }
}