import 'package:car_rental_app_ui/pages/home_page.dart';
import 'package:car_rental_app_ui/pages/location_screen.dart';
import 'package:car_rental_app_ui/pages/profile_screen/profile_screen.dart';
import 'package:car_rental_app_ui/pages/rent_history_screen.dart';
import 'package:car_rental_app_ui/widgets/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter/material.dart';



class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MapScreen(),
    ProfileScreen(),
    RentHistory(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      /*  appBar: appBar(context),
      drawer: drawer(context),*/

      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SizedBox(
                height: size.width * 0.12,
                width: size.width * 0.12,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.bell,

                  ),
                ),
              ),
              label: '',
            ),

            BottomNavigationBarItem(
              icon: SizedBox(
                height: size.width * 0.12,
                width: size.width * 0.12,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.map_marker,
                  ),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: size.width * 0.12,
                width: size.width * 0.12,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.user,
                  ),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: size.width * 0.12,
                width: size.width * 0.12,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.primaryColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.apps,
                  ),
                ),
              ),
              label: '',
            ),
          ],
          elevation: 9,
          selectedLabelStyle: const TextStyle(fontSize: 0),
          unselectedLabelStyle: const TextStyle(fontSize: 0),
          currentIndex: _selectedIndex,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: themeData.brightness == Brightness.dark
              ? Colors.indigoAccent
              : Colors.black,
          unselectedItemColor: const Color(0xff3b22a1),
        onTap: _onItemTapped,

      ),
    );
  }
}

/*

Widget buildBottomNavBar(int currIndex, Size size, ThemeData themeData) {
    int index = 0 ;
  return BottomNavigationBar(
    iconSize: size.width * 0.07,
    elevation: 0,
    selectedLabelStyle: const TextStyle(fontSize: 0),
    unselectedLabelStyle: const TextStyle(fontSize: 0),
    currentIndex: currIndex,
    backgroundColor: const Color(0x00ffffff),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: themeData.brightness == Brightness.dark
        ? Colors.indigoAccent
        : Colors.black,
    unselectedItemColor: const Color(0xff3b22a1),
    onTap: (value) {
      if (value != currIndex) {
        if (value == 0) {
          Get.off(const HomePage());
        }else if(value == 1){
          Get.off(const ProfileScreen());
        }else{
          Get.off(ProfileScreen());
        }
      }
    },
    items: [
      buildBottomNavItem(
        UniconsLine.bell,
        themeData,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.map_marker,
        themeData,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.user,
        themeData,
        size,
      ),
    ],
  );
}
*/
