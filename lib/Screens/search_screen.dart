import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebify/Screens/profile_screen.dart';
import 'package:weebify/models/user_data.dart';
import 'package:weebify/models/user_model.dart';
import 'package:weebify/services/database_service.dart';

class SearchScreen extends StatefulWidget {
  
  SearchScreen({Key key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

    TextEditingController _searchController = TextEditingController();
    Future<QuerySnapshot> _users;

    _buildUserTile(User user){
      return ListTile(
        leading: CircleAvatar(radius: 20.0,
        backgroundImage: user.profileImage.isEmpty ? AssetImage('assets/images/user_placeholder.jpg') 
        : CachedNetworkImageProvider(user.profileImage),
        ),
        title: Text(user.name),
        onTap: () => Navigator.push(
          context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(
                currentUserId: Provider.of<UserData>(context).currentUserId,
                userId: user.id,)
                )
              ) ,
      );
    }
    _clearSearch(){
      WidgetsBinding.instance.addPostFrameCallback((_) => _searchController.clear() );
      _searchController.clear();
      setState(() {
        _users = null;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFFEDF0F6),
      appBar: AppBar(
         backgroundColor: Colors.black,
         title: TextField(
           controller: _searchController,
           style: TextStyle(
             color: Colors.white,
           ),
           cursorColor: Colors.white,
           decoration: InputDecoration(border: InputBorder.none,
           contentPadding: EdgeInsets.symmetric(vertical: 25.0),
           hintText: 'Search',
           hintStyle: TextStyle(
             fontSize: 25.0,
             fontFamily: 'Montserrat',
             color: Colors.white,
           ),
           prefixIcon: Icon(
             Icons.search,
             size: 35.0,
             color: Colors.white,
           ),
           suffixIcon: IconButton(
             icon: Icon(Icons.clear,
             color: Colors.white,
             ),
             onPressed: _clearSearch,
           ),
          ),
          onSubmitted: (input){
            print(input);
            if (input.isNotEmpty){
            setState(() {
              _users = DatabaseService.searchUsers(input);
            });
            }
          },
        ),       
       ),
      body: _users == null ? 
      Center(
        child: Text('Search For a User'),
      )
       : FutureBuilder(future: _users, builder: (context, snapshot) {
         if (!snapshot.hasData){
           return Center(
             child: CircularProgressIndicator(),
           );
         }
         if (snapshot.data.documents.length == 0){
           return Center(
             child: Text('No Users Found try again.'),
           );
         }
         return ListView.builder(
           itemCount: snapshot.data.documents.length,
           itemBuilder: (BuildContext context, int index){
              User user = User.fromDoc(snapshot.data.documents[index]);
              return _buildUserTile(user);
           },
         );
      },
     ),
    );
  }
}