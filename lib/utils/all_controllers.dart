import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/auth_screen_controller.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import '../controller/articles_controller.dart';
import '../controller/disposable_controller.dart';

class AppProviders {
  static List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      Provider.of<ArticlesController>(context, listen: false),
      Provider.of<AuthScreenController>(context, listen: false),
      Provider.of<MyArticlesController>(context, listen: false),
      Provider.of<UserController>(context, listen: false),
    ];
  }

  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}
