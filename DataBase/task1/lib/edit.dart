
import 'package:flutter/material.dart';


import 'db.dart';
import 'main.dart';

class EditPage extends StatefulWidget
{
  String email,name,pass;
  EditPage({required this.email,required this.name,required this.pass});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage>
{

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  MyDb db1 = MyDb();

  @override
  void initState()
  {

    db1.open();
    name.text= widget.name;
    email.text=widget.email;
    pass.text=widget.pass;

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: Text("Edit Data : ${widget.email}"),),
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

                db1.db.rawUpdate("update students set name=?,email=?,password=? where email=?",[n,e,p,widget.email]);
                print("Updated");
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyApp()));
              }, child: Text("Update"))

            ],
          ),
        ),
      ),
    );
  }
}
