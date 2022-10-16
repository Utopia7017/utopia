import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/utils/global_context.dart';
import 'package:utopia/view/screens/AppScreen/components/notification_bell.dart';
import 'package:utopia/view/screens/Drawer/drawer.dart';
import 'package:utopia/view/screens/ExploreScreen/explore_screen.dart';
import '../../../constants/color_constants.dart';

class AppScreen extends StatefulWidget {
  bool internetConnection;

  AppScreen(this.internetConnection);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  final Logger _logger = Logger("AppScreen");

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  late StreamSubscription internetSubscription;

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
    final scaffold =
        ScaffoldMessenger.of(GlobalContext.contextKey.currentContext!);

    internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      bool oldInternetConnection = widget.internetConnection;
      widget.internetConnection =
          await InternetConnectionChecker().hasConnection;
      if (!oldInternetConnection && widget.internetConnection) {
        scaffold.showSnackBar(SnackBar(
            backgroundColor: Colors.green.shade400,
            content: const Text(
              "Reconnected !",
              style: TextStyle(color: Colors.white),
            )));
      } else if (oldInternetConnection && !widget.internetConnection) {
        scaffold.showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade400,
            content: const Text(
              "Connection lost !",
              style: TextStyle(color: Colors.white),
            )));
      }
      setState(() {});
    });
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
      drawer: widget.internetConnection ? CustomDrawer() : const SizedBox(),
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
            onTap: () => (widget.internetConnection)
                ? _handleMenuButtonPressed()
                : _logger.info("Not connected to internet"),
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
                  onTap: () => (widget.internetConnection)
                      ? Navigator.pushNamed(context, '/notifications')
                      : _logger.info("Not connected to internet"),
                  child: Container(
                      width: 35,
                      padding: const EdgeInsets.all(6.5),
                      child: NotificationBell())),
            )
          ],
        ),
        backgroundColor: primaryBackgroundColor,
        body: (widget.internetConnection)
            ? SafeArea(child: ExploreScreen())
            : SafeArea(
                child: Center(
                    child: TextButton(
                        onPressed: () async {
                          final scaffold = ScaffoldMessenger.of(
                              GlobalContext.contextKey.currentContext!);
                          widget.internetConnection =
                              await InternetConnectionChecker().hasConnection;
                          bool oldInternetConnection =
                              widget.internetConnection;
                          widget.internetConnection =
                              await InternetConnectionChecker().hasConnection;
                          if (!oldInternetConnection &&
                              widget.internetConnection) {
                            scaffold.showSnackBar(SnackBar(
                                backgroundColor: Colors.green.shade400,
                                content: const Text(
                                  "Reconnected !",
                                  style: TextStyle(color: Colors.white),
                                )));
                          } else if (oldInternetConnection &&
                              !widget.internetConnection) {
                            scaffold.showSnackBar(SnackBar(
                                backgroundColor: Colors.red.shade400,
                                content: const Text(
                                  "Connection lost !",
                                  style: TextStyle(color: Colors.white),
                                )));
                          }

                          setState(() {});
                        },
                        child: const Text("Retry")))),
      ),
    );
  }
}
