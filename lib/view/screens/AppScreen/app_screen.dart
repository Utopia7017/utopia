import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/global_context.dart';
import 'package:utopia/view/screens/AppScreen/components/notification_bell.dart';
import 'package:utopia/view/screens/Drawer/drawer.dart';
import 'package:utopia/view/screens/ExploreScreen/explore_screen.dart';
import '../../../constants/color_constants.dart';
import '../../../state_controller/state_controller.dart';

class AppScreen extends ConsumerStatefulWidget {
  bool internetConnection;

  AppScreen(this.internetConnection);

  @override
  ConsumerState<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
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
  initState() {
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
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);

    _logger.info("Entering App Screen");
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
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    noInternetIcon,
                    height: displayHeight(context) * 0.35,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Oops, No Internet Connection",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: authBackground,
                        letterSpacing: 0.2,
                        fontSize: 16.5,
                        fontFamily: "Open"),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30),
                    child: Text(
                      "Please make sure your wifi or cellular data is turned on and then try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.8,
                          color: Colors.grey.shade600,
                          fontFamily: "Open",
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: const Color(0xfbe4181e),
                    onPressed: () async {
                      final scaffold = ScaffoldMessenger.of(
                          GlobalContext.contextKey.currentContext!);
                      widget.internetConnection =
                          await InternetConnectionChecker().hasConnection;
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
                    child: Text(
                      "TRY AGAIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ))),
      ),
    );
  }
}
