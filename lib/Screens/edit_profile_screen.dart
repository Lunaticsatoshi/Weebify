import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weebify/models/user_model.dart';
import 'package:weebify/services/database_service.dart';
import 'package:weebify/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();
  File _profileImages;
  String _name = '';
  String _bio = '';
  bool _isLoading = false;

  @override
  void initState() { 
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null){
      setState(() {
        _profileImages = imageFile;
      });
    }
  }

  _displayProfileImage(){
      //No New Profile Image
      if (_profileImages == null){
         //No Image
         if (widget.user.profileImage.isEmpty){
           //Placeholder
           return AssetImage('assets/images/user_placeholder.jpg');
         }
         else {
           //Image Already Exits
           return CachedNetworkImageProvider(widget.user.profileImage);
         }
      }
      else{
        //New Image
        return FileImage(_profileImages);
      }
  }


  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading){
      _formKey.currentState.save();
      
      setState(() {
        _isLoading = true;
      });

     //update user in the database
      String _profileImage ='';

      if (_profileImages == null){
        _profileImage = widget.user.profileImage;
      }
      else{
        _profileImage = await StorageService.uploadUserProfileImage(widget.user.profileImage, 
          _profileImages,); 
      }

      User user = User(
       id: widget.user.id,
       name: _name,
       profileImage: _profileImage,
       bio: _bio,
       );
     //Database Update
     DatabaseService.updateUser(user);

       Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFFEDF0F6),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Edit Profile'),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
            children: <Widget>[
              _isLoading ? LinearProgressIndicator(backgroundColor: Colors.redAccent[200],
              valueColor: AlwaysStoppedAnimation(Colors.redAccent),
              ): SizedBox.shrink(),
             Padding(
                padding: EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: _displayProfileImage(),
                      ),
                      FlatButton(
                        onPressed: _handleImageFromGallery,
                        child: Text('Update Profile Image', style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16.0
                        ),),
                      ),
                      TextFormField(
                        initialValue: _name,
                        style: TextStyle(
                          fontSize: 18.0
                        ),
                        decoration: InputDecoration(
                          icon: Icon(Icons.person,
                          size: 20.0,),
                          labelText: 'User Name'
                        ),
                        validator: (input) => input.trim().length <1 ? 'Please Enter a Valid Name' : null,
                        onSaved: (input) => _name = input,
                      ),
                      Container(
                        height: 80.0,
                        child: TextFormField(
                          initialValue: _bio,
                          style: TextStyle(
                            fontSize: 18.0
                          ),
                          decoration: InputDecoration(
                            icon: Icon(Icons.note,
                            size: 20.0,),
                            labelText: 'Description'
                          ),
                          validator: (input) => input.trim().length >240 ? 'Minimum Character Length Exceeded' : null,
                          onSaved: (input) => _bio = input,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(40.0),
                        height: 40.0,
                        width: 250.0,
                        child: FlatButton(
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                                     ),
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          child: Text('Update Profile',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],  
            ),
        ), 
    );
  }
}