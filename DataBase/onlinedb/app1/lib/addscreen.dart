import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController pname = TextEditingController();
  TextEditingController pprice = TextEditingController();
  TextEditingController pdes = TextEditingController();

  File? _imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: chooseImage,
              child: _imageFile == null
                  ? Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.deepPurple.shade200,
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.deepPurple,
                  ),
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: pname,
              decoration: InputDecoration(
                hintText: "Enter Product Name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: pprice,
              decoration: InputDecoration(
                hintText: "Enter Price",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 10),

            TextField(
              controller: pdes,
              decoration: InputDecoration(
                hintText: "Enter Description",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: uploadData,
              child: Text("Insert Product"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> chooseImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }
  Future<void> uploadData() async {
    if (pname.text.isEmpty ||
        pprice.text.isEmpty ||
        pdes.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fill all fields")));
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Select Image First")));
      return;
    }

    var url = Uri.parse("https://prakrutitech.xyz/ankita/insertdata.php");

    var request = http.MultipartRequest("POST", url)
      ..fields["p_name"] = pname.text
      ..fields["p_price"] = pprice.text
      ..fields["p_des"] = pdes.text
      ..files.add(await http.MultipartFile.fromPath("p_img", _imageFile!.path));

    var response = await request.send();

    final respStr = await response.stream.bytesToString();
    print("Response status: ${response.statusCode}");
    print("Response body: $respStr");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Added Successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to Add Product")),
      );
    }
  }
}
