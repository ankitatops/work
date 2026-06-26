import 'package:flutter/material.dart';
import 'package:task/second.dart';

class FormEx extends StatefulWidget {
  const FormEx({super.key});

  @override
  State<FormEx> createState() => _FormExState();
}

enum Gender { male, female }

class _FormExState extends State<FormEx> {
  Gender _gender = Gender.female;
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  bool cricket = false;
  bool reading = false;
  bool music = false;
  final List<String> _cities = [
    'Ahmedabad',
    'Mumbai',
    'Delhi',
    'Pune',
    'Rajkot',
  ];
  var _selectedCity;

  var _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Form")),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: fname,
                    decoration: InputDecoration(
                      labelText: "Enter firstname ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.00),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter  firstname";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: lname,
                    decoration: InputDecoration(
                      labelText: "Enter lastname",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.00),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter lastname";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "Enter email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.00),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter email";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select City",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    value: _selectedCity,
                    items: _cities
                        .map(
                          (city) =>
                              DropdownMenuItem(value: city, child: Text(city)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select a city";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      const Text(
                        "Select Gender:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<Gender>(
                              title: const Text('Male'),
                              value: Gender.male,
                              groupValue: _gender,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<Gender>(
                              title: const Text('Female'),
                              value: Gender.female,
                              groupValue: _gender,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Hobbies:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CheckboxListTile(
                        title: const Text("Cricket"),
                        value: cricket,
                        onChanged: (value) {
                          setState(() {
                            cricket = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text("Reading"),
                        value: reading,
                        onChanged: (value) {
                          setState(() {
                            reading = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text("Music"),
                        value: music,
                        onChanged: (value) {
                          setState(() {
                            music = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        // Gather hobbies
                        List<String> hobbies = [];
                        if (cricket) hobbies.add("Cricket");
                        if (reading) hobbies.add("Reading");
                        if (music) hobbies.add("Music");

                        // Navigate to Second page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondPage(
                              firstName: fname.text,
                              lastName: lname.text,
                              email: email.text,
                              gender: _gender.name,
                              city: _selectedCity,
                              hobbies: hobbies,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
