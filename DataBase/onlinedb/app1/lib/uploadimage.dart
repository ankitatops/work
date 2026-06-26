

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Uploadimage extends StatefulWidget
{
  const Uploadimage({super.key});

  @override
  State<Uploadimage> createState() => _UploadimageState();
}

class _UploadimageState extends State<Uploadimage>
{
  TextEditingController name = TextEditingController();
  File _imageFile = File("");
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: Text("Upload data"),),
      body: Center
        (
        child: Column
          (
          children:
          [
            TextField(controller:name,decoration: InputDecoration(hintText: "Enter Category"),),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: ()
            {
              chooseimage();

            }, child: Text("Choose File")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: ()
            {
              uploadimage();
            }, child: Text("Upload")),
          ],
        ),
      ),
    );
  }

  Future<void> chooseimage() async
  {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null)
    {
      setState(()
      {
        _imageFile = File(pickedFile.path);
      });
    }

  }

  Future<void> uploadimage()async
  {
    try
    {
      var url = Uri.parse("https://prakrutitech.xyz/ankita/insertdata.php");

      var request = http.MultipartRequest('POST', url)
        ..fields['p_name'] = name.text.toString()
        ..fields['p_price'] = "100"
        ..fields['p_des'] = "aaaa"
        ..files.add(await http.MultipartFile.fromPath('p_img', _imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Data uploaded successfully');

      } else {
        print('Failed to upload data. Error: ${response.statusCode}');
      }


    }
    catch(e)
    {
      print(e);
    }
  }
}
