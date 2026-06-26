import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final List<String> hobbies;

  final dynamic city;

  const SecondPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.hobbies,
    required this. city,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("First Name: $firstName"),
            Text("Last Name: $lastName"),
            Text("Email: $email"),
            Text("Gender: $gender"),
            Text("Hobbies: ${hobbies.join(', ')}"),
            Text(" City: $city"),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Go Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
