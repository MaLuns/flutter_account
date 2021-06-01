import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shici/pages/tab_page/tab_chart_page.dart';
import 'package:shici/pages/tab_page/tab_home/tab_home_page.dart';
import 'package:shici/pages/tab_page/tab_my_page.dart';
import 'package:shici/routes/routes.dart';

class HomaPage extends StatefulWidget {
  @override
  _HomaPageState createState() => _HomaPageState();
}

class _HomaPageState extends State<HomaPage> {
  int currentIndex = 0;
  PageController _pageController;
  List<Widget> pages = [
    TabHomePage(),
    TabChartPage(),
    TabMyPage(),
    TabMyPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: this.currentIndex);
  }

  void _changePage(int index) {
    if (index == 2) {
      return;
    }
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
        _pageController.jumpToPage(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcfcfc),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: this._pageController,
        children: this.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: _changePage,
        currentIndex: currentIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '明细'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '图表'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '记一笔'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: '社区'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '我的'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new Builder(
        builder: (BuildContext context) => Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color: Color(0x33000000), offset: Offset(0, -1), blurRadius: 1.0, spreadRadius: -1)],
          ),
          child: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.black),
            heroTag: null,
            elevation: 0,
            backgroundColor: Colors.yellow,
            highlightElevation: 0.0,
            onPressed: () {
              Get.toNamed(AppRoutes.AddAccount);
            },
            mini: false,
            shape: new CircleBorder(),
            isExtended: false,
          ),
        ),
      ),
    );
  }
}
