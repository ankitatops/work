import 'package:flutter/material.dart';

class task extends StatefulWidget {
  const task({super.key});

  @override
  State<task> createState() => _MyAppState();
}

class _MyAppState extends State<task>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: Text("Navigation Drawer Example"),),
      body: Center(),
        bottomNavigationBar: BottomNavigationBar(items:
        [

          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.green
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
              backgroundColor: Colors.yellow
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.blue,

          ),

        ]),
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
              Navigator.of(context).pop();
             // Navigator.push(context,MaterialPageRoute(builder: (context) => BottomNavigationBar1()));
            },),
            ListTile(leading: Icon(Icons.contact_mail),title: Text("Contact"),onTap: ()
            {
              Navigator.of(context).pop();
              //Navigator.push(context,MaterialPageRoute(builder: (context) => BottomNavigationBar1()));
            },)
          ],
        ),
      ),
    );
  }
}