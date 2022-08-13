import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/advert.dart';
import 'package:sokasokoo/screens/Main/profile.dart';
import 'package:sokasokoo/screens/Main/search.dart';
import 'package:sokasokoo/utils.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainHome> {
  int _currentIndex = 0;
  final List<Widget> _screens = <Widget>[
    const AdvertScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  void _updateIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setUser();
  }

  void setUser() async {
    User data = await Api().currentUser();
    Provider.of<UserProvider>(context, listen: false).setUser(data);
    Provider.of<UserProvider>(context, listen: false).fetchRegions();
    Provider.of<UserProvider>(context, listen: false).fetchDistricts();
    Provider.of<UserProvider>(context, listen: false).fetchWards();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _lastExitTime = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(_lastExitTime) >=
            const Duration(seconds: 2)) {
          const snack = SnackBar(
            content: Text('Press the back button again to exist Sokasoko'),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          _lastExitTime = DateTime.now();
          return false;
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _updateIndex,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: 'My Account',
              icon: Icon(Icons.account_circle_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
