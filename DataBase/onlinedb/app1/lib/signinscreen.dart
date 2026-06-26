import 'dart:convert';
import 'package:app1/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signupscreen.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late SharedPreferences sharedPreferences;
  var newuser;
  bool _obscureText = true;

  @override
  void initState() {
    checkvalue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://wallpaperaccess.com/full/317501.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Container(
              padding: EdgeInsets.all(22),
              width: 310,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  TextFormField(
                    controller: password,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText; // toggle
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      String myemail = email.text.toString();
                      String mypass = password.text.toString();
                      sharedPreferences.setBool("tops", false);
                      sharedPreferences.setString("email", myemail);
                      login(email: myemail, pass: mypass);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  login({required email, required pass}) async {
    var url = Uri.parse("https://prakrutitech.xyz/ankita/signin.php");
    var resp = await http.post(url, body: {"email": email, "password": pass});
    var data = json.decode(resp.body);

    if (data == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failed")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Success")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewScreen()),
      );
    }
  }

  checkvalue() async {
    sharedPreferences = await SharedPreferences.getInstance();
    newuser = sharedPreferences.getBool("tops") ?? true;

    if (newuser == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewScreen()),
      );
    }
  }
}
