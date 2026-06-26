import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Updatescreen extends StatefulWidget {
  final id;
  final pname;
  final pprice;
  final pdes;
  //final pimg;

  Updatescreen({
    required this.id,
    required this.pname,
    required this.pprice,
    required this.pdes,
   // required this.pimg,
  });

  @override
  State<Updatescreen> createState() => _UpdatescreenState();
}

class _UpdatescreenState extends State<Updatescreen> {
  TextEditingController pname = TextEditingController();
  TextEditingController pprice = TextEditingController();
  TextEditingController pdes = TextEditingController();
  //String? imageBase64;

  File? _imageFile;

  final picker = ImagePicker();

  @override
  void initState() {
    pname.text = widget.pname;
    pprice.text = widget.pprice;
    pdes.text = widget.pdes;
    //imageBase64 = widget.pimg;
    super.initState();
  }

  // Future<void> pickImage() async {
  //   final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     File img = File(picked.path);
  //     imageBase64 = base64Encode(await img.readAsBytes());
  //     setState(() {});
  //   }
  // }
  void deleteImage() {
    setState(() {
      //imageBase64 = null;
    });
  }
  updatedata() async {
    var url = Uri.parse("https://prakrutitech.xyz/ankita/update.php");
    var request = http.MultipartRequest("POST", url);

    request.fields["id"] = widget.id;
    request.fields["p_name"] = pname.text;
    request.fields["p_price"] = pprice.text;
    //request.fields["p_des"] = widget.pimg;



    // if (_imageFile != null) {
    //   request.files.add(
    //     await http.MultipartFile.fromPath("p_img", _imageFile!.path),
    //   );
    // }

    await request.send();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Product")),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // _imageFile == null
            //     ? Image.network(
            //   "https://prakrutitech.xyz/ankita/uploads/${widget.pimg}",
            //   width: 150,
            //   height: 150,
            //   fit: BoxFit.cover,
            // )
            //     : Image.file(_imageFile!, width: 150, height: 150),
            //
            // ElevatedButton(
            //   onPressed:pickImage ,
            //   child: Text("Change Image"),
            // ),

            TextField(controller: pname),
            TextField(controller: pprice),
            TextField(controller: pdes),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: updatedata,
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
