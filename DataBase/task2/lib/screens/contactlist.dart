
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../color.dart';
import '../database/dbhelper.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactlistState();
}

class _ContactlistState extends State<ContactList>
{
  final dbHelper = DbHelper.instance;
  List<Map<String, dynamic>> allCategoryData = [];

  @override
  void initState()
  {

    _query();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea
      (child: Scaffold
      (
      appBar: AppBar(title: Text("Contacts"),),
      body: Column
        (
        children:
        [
          Expanded(child:
          ListView.builder
            (
            itemCount: allCategoryData.length,
            itemBuilder: (BuildContext context, int index)
            {
              var item = allCategoryData[index];
              Uint8List bytes = base64Decode(item['profile']);

              return Container
                (
                  color: MyColors.orangeTile,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Column
                    (
                    children:
                    [
                      Row
                        (
                        children:
                        [
                          SizedBox
                            (
                            width: 20,
                          ),
                          CircleAvatar(child: Image.memory(bytes,fit: BoxFit.cover,),minRadius: 20,maxRadius: 25,),
                          Text("${item['name']}"),
                          Text("${item['lname']}"),

                          Spacer(),
                          IconButton(onPressed: ()
                          {
                            _delete(item['_id']);
                          }, icon: Icon(Icons.delete),color:Colors.red,)
                        ],
                      )

                    ],
                  )
              );

            },

          ))
        ],
      ),
    ));

  }
  void _query() async
  {
    final allRows = await dbHelper.querycontact();
    allRows.forEach(print);
    allCategoryData = allRows;
    print("tops1234");
    print(allCategoryData.length);
    setState(() {});
  }

  void _delete(int id)async
  {
    final rowsDeleted = await dbHelper.deleteContact(id);
    print('deleted $rowsDeleted row(s): row $id');
    _query();
  }

}
