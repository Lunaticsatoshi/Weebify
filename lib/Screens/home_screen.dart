import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebify/Screens/activity_screen.dart';
import 'package:weebify/Screens/feed_screen.dart';
import 'package:weebify/Screens/post_screen.dart';
import 'package:weebify/Screens/profile_screen.dart';
import 'package:weebify/Screens/search_screen.dart';
import 'package:weebify/models/user_data.dart';

class HomeScreen extends StatefulWidget {
    HomeScreen({Key key}) : super(key: key);
    static final String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  PageController _pageController;

  @override
  void initState(){
   super.initState();
   _pageController = PageController();
  }


  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
       body: PageView(
         controller: _pageController,
         children: <Widget>[
           FeedScreen(currentUserId: currentUserId,),
           SearchScreen(),
           PostScreen(),
           ActivityScreen(),
           ProfileScreen(
           currentUserId: currentUserId ,
           userId: currentUserId
           ),
         ],
         onPageChanged: (int index){
           setState((){
           _page = index;           
           });
         },
       ),
       bottomNavigationBar: CurvedNavigationBar(
          items: <Widget>[
            Icon(Icons.home, size: 30, color: Colors.white,),
            Icon(Icons.search, size: 30, color: Colors.white,),
            Icon(Icons.photo_camera, size: 30, color: Colors.white,),
            Icon(Icons.notifications, size: 30, color: Colors.white,),
            Icon(Icons.account_circle, size: 30, color: Colors.white,),
          ],
          key: _bottomNavigationKey,
          color: Colors.black,
          backgroundColor: Color(0xFFEDF0F6),
          animationCurve: Curves.easeOutCubic,
          animationDuration: Duration(milliseconds: 600),
          height: 50,
          index: _page,
          onTap: (index) {
            setState(() {
              _page = index;
            });
            _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeOutCubic);
          },
        ),

    );
  }
}