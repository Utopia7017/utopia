import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/view/screens/AppScreen/app_screen_body.dart';
import 'package:utopia/view/screens/AppScreen/drawer.dart';
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
        ),
        backgroundColor: primaryBackgroundColor,
        body: AppScreenBody(),
      ),
    );
  }
}
