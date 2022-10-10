import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/view/screens/AppScreen/components/notification_bell.dart';
import 'package:utopia/view/screens/Drawer/drawer.dart';
import 'package:utopia/view/screens/ExploreScreen/explore_screen.dart';
import '../../../constants/color_constants.dart';

class AppScreen extends StatefulWidget {
  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

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
    return AdvancedDrawer(
      backdropColor: drawerBackground,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: CustomDrawer(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryBackgroundColor,
          title: const Text(
            'Utopia',
            style: TextStyle(
                color: authBackground,
                fontFamily: "Play",
                fontSize: 22,
                fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: _handleMenuButtonPressed,
            child: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Image.asset(
                      value.visible ? menuIconClose : menuIcon,
                      height: 25,
                      key: ValueKey<bool>(value.visible),
                    ));
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/notifications'),
                  child: NotificationBell()),
            )
          ],
        ),
        backgroundColor: primaryBackgroundColor,
        body: SafeArea(child: ExploreScreen()),
      ),
    );
  }
}
