import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'addscreen.dart';
import 'mymodel.dart';
import 'signinscreen.dart';

void main() {
  runApp(MaterialApp(home: Signinscreen(), debugShowCheckedModeBanner: false));
}

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  late SharedPreferences sharedPreferences;
  String myuser = "";

  @override
  void initState() {
    super.initState();
    checkdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Data"),
        actions: [
          IconButton(
            onPressed: () {
              sharedPreferences.setBool("tops", true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Signinscreen()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("No Data Found"));
          }
          if (snapshot.hasData) {
            List data = snapshot.data as List;
            return MyModel(list: data);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  getdata() async {
    var url = Uri.parse("https://prakrutitech.xyz/ankita/view.php");
    var resp = await http.get(url);
    return jsonDecode(resp.body);
  }

  checkdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      myuser = sharedPreferences.getString("email") ?? "";
    });
  }
}
