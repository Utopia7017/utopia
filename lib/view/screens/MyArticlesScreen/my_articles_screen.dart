import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';

class MyArticleScreen extends StatefulWidget {
  

  @override
  State<MyArticleScreen> createState() => _MyArticleScreenState();
}

class _MyArticleScreenState extends State<MyArticleScreen> with TickerProviderStateMixin {

 late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: Text('My Article'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Published',),
            Tab(text: 'Drafts',),
          ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('Published articles'),),
          Center(child: Text('Draft articles'),),
        ]),
    );
  }
}

