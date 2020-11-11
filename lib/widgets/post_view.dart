import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weebify/Screens/profile_screen.dart';
import 'package:weebify/models/post_model.dart';
import 'package:weebify/models/user_model.dart';

class PostView extends StatelessWidget {
  final String currentUserId;
  final Post post;
  final User author;

  const PostView({Key key,this.currentUserId, this.post, this.author}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0,),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: <Widget>[
                   GestureDetector(
                     onTap: () => Navigator.push(context, MaterialPageRoute(
                       builder: (_) => ProfileScreen(
                         currentUserId: currentUserId,
                         userId: post.authorId,
                       ) 
                       )
                      ),
                     child: Container(
                       padding: EdgeInsets.symmetric(
                         horizontal: 10.0,
                         vertical: 10.0
                       ),
                       child: Row(
                          children: <Widget>[
                            CircleAvatar(radius: 25.0,
                            backgroundColor: Colors.grey,
                            backgroundImage: author.profileImage.isEmpty ? 
                            AssetImage('assets/images/user_placeholder.jpg') :
                            CachedNetworkImageProvider(author.profileImage),
                            ),
                            SizedBox(width: 8.0,),
                            Text(author.name,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),),
                            SizedBox(width: 165.0,),
                            IconButton(
                              icon: Icon(Icons.more_horiz),
                              onPressed: () => print('More'),
                            )
                          ],
                        ),
                     ),
                   ),
                  Container(
                    margin: EdgeInsets.all(9.0),
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 5),
                          blurRadius: 8.0
                          ),
                          ],
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(post.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                           IconButton(
                             icon: Icon(Icons.favorite_border),
                             iconSize: 30.0,
                             onPressed: () {},
                           ),
                           IconButton(
                             icon: Icon(Icons.mode_comment),
                             iconSize: 30.0,
                             onPressed: () {},
                           ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text('0 Upvotes',
                          style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                          ),
                         ),
                        ),
                        SizedBox(height: 4.0,),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 12.0,
                              right: 6.0,
                              ),
                              child: Text(
                                author.name,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                post.caption,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Montserrat',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0,),
                      ],
                    ),
                  ),
                ],
              ),
            
          ),
        ),

      ],
    );
  }
}