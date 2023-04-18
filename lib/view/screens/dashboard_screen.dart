import 'package:delivrd_driver/helper/network_info.dart';
import 'package:delivrd_driver/helper/responsive_helper.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/view/screens/history_screen.dart';
import 'package:delivrd_driver/view/screens/home_screen.dart';
import 'package:delivrd_driver/view/screens/menu/menu_screen.dart';
import 'package:delivrd_driver/view/screens/profile_screen.dart';
import 'package:delivrd_driver/view/screens/accepted_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
   late int pageIndex;

  DashboardScreen({required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  List<Widget>? _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();


  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(),
      AcceptedScreen(),
      HistoryScreen(),
      MenuScreen(),
    //  CompanyOrdersScreen(isRunning: true),
      /*CompanyMenuScreen(onTap: (int pageIndex) {
        _setPage(pageIndex);
      }),*/
    ];

    if(ResponsiveHelper.isMobilePhone()) {
      NetworkInfo.checkConnectivity(_scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'); return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: ResponsiveHelper.isMobile(context) ? BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,

          items: [
            _barItem('assets/icon/home-icon.png', 'Home', 0),
            _barItem('assets/icon/running-icon.png', 'Running', 1),
            _barItem('assets/icon/history-icon.png', 'History', 2),
            _barItem('assets/icon/menu-icon.png', 'Menu', 3),

          ],
          onTap: (int index) {
            _setPage(index);
          },
        ) : SizedBox(),

        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens!.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens![index];
          },
        ),
      ),
    );
  }
  //Image.asset("assets/icon/motorcycleicon.png",height: 40),

  BottomNavigationBarItem _barItem(String icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none, children: [
        //   Icon(icon, color: index == _pageIndex ? Theme.of(context).primaryColor : ColorResources.COLOR_GREY, size: 25),
        ImageIcon(
          AssetImage(icon),
          color: index == _pageIndex ? Colors.red : Colors.grey,
        ),
      ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}

