import 'package:flutter/material.dart';

class MyModel extends StatelessWidget {
  var list;

  MyModel({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Image.network(list[index]["imageurl"]),
                SizedBox(height: 10),
                Text(list[index]["name"]),
                Text(list[index]["realname"]),
                Text(list[index]["team"]),
                Text(list[index]["firstappearance"]),
                Text(list[index]["createdby"]),
                Text(list[index]["publisher"]),
                Text(
                  list[index]["bio"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
