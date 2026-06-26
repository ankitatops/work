import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'update.dart';

class MyModel extends StatelessWidget {
  final List list;

  const MyModel({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withOpacity(0.05),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          var item = list[index];

          String imgUrl = "";
          if (item["p_img"] != null && item["p_img"].toString().isNotEmpty) {
            imgUrl =
            "https://prakrutitech.xyz/ankita/uploads/${item["p_img"]}";
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 5,
              shadowColor: Colors.blue.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                        imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
                        child: imgUrl.isEmpty
                            ? const Icon(Icons.image_not_supported, size: 40)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            item["id"].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["p_name"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "₹ ${item["p_price"]}",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Updatescreen(
                                  id: item["id"],
                                  pname: item["p_name"],
                                  pprice: item["p_price"],
                                  pdes: item["p_des"],
                                 // pimg: item["p_img"],
                                ),
                              ),
                            );
                          },
                        ),


                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, item["id"]);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      item["p_des"],
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  void _confirmDelete(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Are you sure?",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text("Do you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deletedata(id);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ViewScreen()),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> deletedata(id) async {
    var url = Uri.parse("https://prakrutitech.xyz/ankita/delete.php");
    var resp = await http.post(url, body: {"id": id});
    print("Delete API Status: ${resp.statusCode}");
  }
}
