import 'package:flutter/material.dart';
import 'package:task1/edit.dart';
import 'AddPage.dart';
import 'db.dart';

void main()
{
  runApp(MaterialApp(home:MyApp(),debugShowCheckedModeBanner:false,));
}
class MyApp extends StatefulWidget
{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{

  MyDb db1  = MyDb();
  List<Map> slist = [];
  bool isLoading = true; // show a loader while DB opens

  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData() async {
    await db1.open(); // wait until DB opens
    await getdata();  // then fetch data
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        appBar: AppBar(title: Text("Sqflite CRUD"),actions:
        [
          IconButton(onPressed: ()
          {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AddPage()));

          }, icon: Icon(Icons.add))
        ],),
        body:  isLoading
            ? Center(child: CircularProgressIndicator()) // show loading state
            : slist.isEmpty
            ? Center(child: Text("No data found."))
            : SingleChildScrollView(
          child: Column
            (
              children:slist.map((stuone)
              {

                return Card
                  (
                    child: ListTile
                      (
                      leading:Icon(Icons.person),
                      title: Text(stuone["name"]),
                      subtitle:Text(stuone["email"]),
                      trailing: Wrap
                        (
                        children:
                        [
                          IconButton(onPressed: ()
                          {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => EditPage(email:stuone["email"],name:stuone["name"],pass:stuone["password"])));

                          }, icon: Icon(Icons.edit)),
                          IconButton(onPressed: ()
                          {
                            db1.db.rawDelete("delete from students where email=?",[stuone["email"]]);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Record Deleted")));
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyApp()));
                          }, icon: Icon(Icons.delete))

                        ],
                      ),
                    )
                );
              }).toList()


          ),
        )

    );
  }

  Future<void> getdata() async {
    Future.delayed(Duration(milliseconds: 500),()async
    {
      slist = await db1.db.rawQuery('SELECT * FROM students');
      setState(()
      {

      });
    });
  }

// void getdata()
// {
//   Future.delayed(Duration(milliseconds: 500),()async
//   {
//     slist = await db1.db.rawQuery('SELECT * FROM students');
//     setState(()
//     {
//
//     });
//   });
// }
}