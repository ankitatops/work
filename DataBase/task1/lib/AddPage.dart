
import 'package:flutter/material.dart';
import 'db.dart';
import 'main.dart';

class AddPage extends StatefulWidget
{
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage>
{

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  MyDb db1 = MyDb();

  @override
  void initState()
  {

    db1.open();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: Text("Add Data"),),
      body: Padding(
        padding: EdgeInsets.all(16.00),
        child: Center
          (
          child: Column
            (
            children:
            [
              TextFormField(controller:name,decoration: InputDecoration(hintText: "Enter Name"),),
              SizedBox(height: 10,),
              TextFormField(controller:email,decoration: InputDecoration(hintText: "Enter Email"),),
              SizedBox(height: 10,),
              TextFormField(controller:pass,decoration: InputDecoration(hintText: "Enter Password"),),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: ()
              {
                String n = name.text.toString();
                String e = email.text.toString();
                String p = pass.text.toString();

                db1.db.rawInsert("insert into students (name,email,password) values (?,?,?)",[n,e,p]);
                print("Inserted");
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyApp()));
              }, child: Text("Insert"))

            ],
          ),
        ),
      ),
    );
  }
}
