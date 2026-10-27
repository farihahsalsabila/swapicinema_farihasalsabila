import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:swapi_cinema_app/src/app/cinema_location/cinema_location_page.dart';
import 'package:swapi_cinema_app/src/app/movie/list_movie_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ptcController = PersistentTabController(initialIndex: 0);
  @override
  void dispose() {
    _ptcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    PersistentTabView(context,
        controller: _ptcController,
        screens: const [
          ListMoviePage(),
          CinemaLocationPage(),
        ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: const Color(0xFFFFE81F),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.map),
          title: ("Cinemas"),
          activeColorPrimary: const Color(0xFFFFE81F),
          inactiveColorPrimary: Colors.grey,
        ),
      ],
      backgroundColor: const Color(0xFF141414),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style3,
    ));
  }
}
