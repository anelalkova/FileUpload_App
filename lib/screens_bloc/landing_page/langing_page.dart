import 'package:file_upload_app_part2/bloc/main/landing_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../documents_page/documents_page.dart';

const double iconSize = 25;

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
      icon: Icon(Icons.home, size: iconSize),
      label: 'Home',
  ),
  BottomNavigationBarItem(
      icon: Icon(Icons.person, size: iconSize),
      label: 'Account',
  ),
];

List<Widget> bottomNavScreens = <Widget>[
  const DocumentsPage(),
 /* const DocumentScreen(),*/
];

class LandingPage extends StatelessWidget{
  LandingPage({super.key});

  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LandingPageBloc, LandingPageState>(
        builder: (context, state){
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                PageView.builder(
                    controller: _pageController,
                  itemCount: bottomNavScreens.length,
                  physics: currentIndex == 0 ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                      return bottomNavScreens[index];
                  },
                  onPageChanged: (int index){
                      currentIndex = index;
                      context.read<LandingPageBloc>().add(
                        TabChange(tabIndex: index),
                      );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        borderRadius: BorderRadius.circular(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: BottomNavigationBar(
                            items: bottomNavItems,
                            currentIndex: state.tabIndex,
                            backgroundColor: Colors.transparent,
                            onTap: (int index) {
                              int duration = 200;
                             /* if((currentIndex - index).abs() > 1){
                                duration = 600;
                              }*/
                              _pageController.animateToPage(
                                  index,
                                  duration: Duration(milliseconds: duration),
                                  curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        listener: (context, state) {},
    );
  }
}