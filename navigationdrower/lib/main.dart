import 'package:flutter/material.dart';
import 'package:navigationdrower/main2.dart';
import 'package:navigationdrower/task.dart';
void main()
{
  runApp(MaterialApp(home:MyApp()));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: Text("Navigation Drawer Example"),),
      body: Center(),
      drawer: Drawer
        (
        child: Column
          (
          children:
          [
            UserAccountsDrawerHeader(accountName: Text("Tops Technologies"), accountEmail: Text("tops@gmail.com")),
            ListTile(leading: Icon(Icons.home),title: Text("Home"),onTap: ()
            {
             // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomNavigationBar1()));
              Navigator.of(context).pop();
            },),
            ListTile(leading: Icon(Icons.person),title: Text("About"),onTap: ()
            {
              //Navigator.of(context).pop();
              Navigator.push(context,MaterialPageRoute(builder: (context) => BottomNavigationBar1()));
            },),
            ListTile(leading: Icon(Icons.contact_mail),title: Text("Contact"),onTap: ()
            {
              //Navigator.of(context).pop();
              Navigator.push(context,MaterialPageRoute(builder: (context) => task()));
            },)
          ],
        ),
      ),
    );
  }
}