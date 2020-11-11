import 'package:flutter/material.dart';
import 'package:weebify/Screens/profile_screen.dart';
import 'package:weebify/models/post_model.dart';
import 'package:weebify/models/user_model.dart';
import 'package:weebify/services/auth_service.dart';
import 'package:weebify/services/database_service.dart';
import 'package:weebify/widgets/post_view.dart';

class FeedScreen extends StatefulWidget {


static final String id = 'feed_screen';
final String currentUserId;
FeedScreen({Key key, this.currentUserId}) : super(key: key);


  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with AutomaticKeepAliveClientMixin {
  List<Post> _posts = [];
  bool keepAlive = false;

  @override
  void initState() {
    super.initState();
    _setupFeed();
    _doAsyncStuff();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);
    List<Post> userPosts = await DatabaseService.getUserPosts(widget.currentUserId);
    setState(() {
      _posts = [...posts, ...userPosts];
    });
  }

  Future _doAsyncStuff() async{
    keepAlive = true;
    updateKeepAlive();
    //Keeping Alive

    await Future.delayed(Duration(hours: 1));
    
    keepAlive = false;
    updateKeepAlive();
    //Can be disposed whenever required
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.black,
         title: Text('Weebify', 
           style: TextStyle(color: Colors.white,
          fontFamily: 'Billabong',
          fontSize: 35.0,),
          textAlign: TextAlign.center,
          ),       
       ),
      backgroundColor: Color(0xFFEDF0F6),
      body: _posts.length > 0 
       ? RefreshIndicator(
         onRefresh: () => _setupFeed(),
         child: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int index){
         Post post = _posts[index];
         return FutureBuilder(
           future: DatabaseService.getUserWithId(post.authorId),
           builder: (BuildContext context, AsyncSnapshot snapshot){
             if (!snapshot.hasData) {
               return SizedBox.shrink();
             }
             User author = snapshot.data;
             return PostView(
               currentUserId: widget.currentUserId,
               post: post,
               author: author,
             );
           },
         );
        },
      )
    )
      : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

   @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => keepAlive;
}
