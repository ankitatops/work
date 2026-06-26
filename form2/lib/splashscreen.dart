import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'main.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkInternetAndNavigate();
  }
  Future<void> _checkInternetAndNavigate() async {
    // Internet connection check
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // Internet is available → Go next after 5 sec
      Timer(
        const Duration(seconds: 5),
            () =>
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FormEx()),
            ),

      );
    }
    else {
      // No Internet → Show Alert
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            AlertDialog(
              title: const Text("No Internet"),
              content: const Text("Please turn on Mobile Data or WiFi."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    _checkInternetAndNavigate(); // recheck
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network("https://www.shutterstock.com/image-vector/loading-bar-icons-website-load-260nw-2508563715.jpg"),
        //child:Lottie.asset('assets/animation.json'),
      ),
    );
  }
}
class FormEx extends StatelessWidget {
  const FormEx({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("FormEx Page Loaded ✅")),
    );
  }
}
