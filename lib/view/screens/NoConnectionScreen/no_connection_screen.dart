import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({super.key});

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  late StreamSubscription internetSubscription;
  bool isDeviceConnected = false;
  bool alert = false;

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getConnectivity();
  }

  getConnectivity() {
    internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && !alert) {
        showInternetError();
        setState(() {
          alert = true;
        });
      }
    });
  }

  showInternetError() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "No Internet Connection",
            style: TextStyle(color: Colors.blue.shade600, fontSize: 15),
          ),
          content: const Text(
            "Please check your internet connection before trying again !",
            style: TextStyle(fontSize: 13.5),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    alert = false;
                  });
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected) {
                    showInternetError();
                    setState(() {
                      alert = true;
                    });
                  }
                },
                child: const Text("Retry"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
