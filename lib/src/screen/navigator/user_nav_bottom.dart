import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:chat/src/screen/chat/chat_page.dart';
import 'package:chat/src/screen/home/user_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserNavBottom extends StatefulWidget {
  final titles = ['Home', 'Chat'];
  final colors = [
    Colors.red,
    Colors.teal,
  ];
  final icons = [
    AssetImage('assets/images/ic_home_nav.png'),
    AssetImage('assets/images/ic_chat.png'),
  ];

  @override
  _UserNavBottomState createState() => _UserNavBottomState();
}

class _UserNavBottomState extends State<UserNavBottom> {
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;

  @override
  void initState() {
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);

    super.initState();
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification &&
        scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            checkUserDragging(scrollNotification);
            return;
          },
          child: PageView(
            controller: _pageController,
            children: <Widget>[
              UserHomePage(),
              ChatPage(),
            ],
            onPageChanged: (page) {},
          ),
        ),
        bottomNavigationBar: BubbledNavigationBar(
          controller: _menuPositionController,
          initialIndex: 0,
          itemMargin: EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: Color(0xff242424),
          defaultBubbleColor: Colors.blue,
          onTap: (index) {
            _pageController.animateToPage(index,
                curve: Curves.easeInOutQuad,
                duration: Duration(milliseconds: 600));
          },
          items: widget.titles.map((title) {
            var index = widget.titles.indexOf(title);

            return BubbledNavigationBarItem(
              icon: getIcon(index, Colors.white),
              activeIcon: getIcon(index, Colors.black),
              bubbleColor: Colors.white,
              title: Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            );
          }).toList(),
        ));
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ImageIcon(widget.icons[index], size: 35, color: color),
    );
  }
}
