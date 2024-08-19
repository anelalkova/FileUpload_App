import 'package:file_upload_app_part2/bloc/main/landing_page_bloc.dart';
import 'package:file_upload_app_part2/screens_bloc/account_page/account_page.dart';
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
  DocumentsPage(),
  AccountPage(),
];

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LandingPageBloc, LandingPageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: bottomNavScreens.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return bottomNavScreens[index];
                },
                onPageChanged: (int index) {
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
                    padding: const EdgeInsets.all(30.0),
                    child: Material(
                      color: const Color.fromRGBO(242, 235, 251, 1),
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BottomNavigationBar(
                          items: bottomNavItems,
                          currentIndex: state.tabIndex,
                          backgroundColor: const Color.fromRGBO(212, 187, 252, 0.8),
                          selectedItemColor: Colors.white,
                          unselectedItemColor: Colors.grey,
                          onTap: (int index) {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                            context.read<LandingPageBloc>().add(
                              TabChange(tabIndex: index),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
