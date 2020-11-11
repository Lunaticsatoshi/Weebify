import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:weebify/models/post_model.dart';
import 'package:weebify/models/user_data.dart';
import 'package:weebify/services/database_service.dart';
import 'package:weebify/services/storage_service.dart';

class PostScreen extends StatefulWidget {

  PostScreen({Key key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;

  _showSelectImageDialog(){
    return Platform.isIOS ? _iosBottomSheet(context) : _androidDialog(context);
  }

  _iosBottomSheet(context){
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context){
        return CupertinoActionSheet(
          title: Text('Create Post'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('Upload File'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
        );
      },
    );
  }
  _androidDialog(context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return SimpleDialog(
          title: Text('Create Post'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('Upload Photo'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text('Cancel',
              style: TextStyle(
                color: Colors.redAccent,
              ),),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _handleImage(ImageSource source) async{
    Navigator.pop(context);
     File imageFile = await ImagePicker.pickImage(source: source);
     if (imageFile != null){
       imageFile = await _cropImage(imageFile);
       setState(() {
         _image = imageFile;
       });
     }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(
        ratioX: 1.0,
        ratioY: 1.0,
      ),
    );
    return croppedImage;
  }

  _submit() async {
    if (!_isLoading && _image != null && _caption.isNotEmpty){
      setState(() {
        _isLoading = true;
      });

      //Create Post
      String imageUrl = await StorageService.uploadPost(_image);
      Post post = Post(
        imageUrl: imageUrl,
        caption: _caption,
        likes: 0,
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseService.createPost(post);

      //Reset Data
      _captionController.clear();
      setState(() {
        _caption = '';
        _image = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width; 
    return Scaffold(
       backgroundColor: Color(0xFFEDF0F6),
      appBar: AppBar(
         backgroundColor: Colors.black,
         title: Text('Weebify', 
           style: TextStyle(color: Colors.white,
          fontFamily: 'Billabong',
          fontSize: 35.0,),
          textAlign: TextAlign.center,
          ),  
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: _submit,
            ),
          ],     
       ),
      body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
            child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                _isLoading ? Padding(padding: EdgeInsets.only(bottom: 10.0),
                child:LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                ),
                )
                : SizedBox.shrink(),
                 GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: Container(
                    height: width,
                    width: width,
                    color: Colors.grey[300],
                    child: _image == null ? Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white70,
                      size: 150.0,
                    ) 
                    : Image( image: FileImage(_image),
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Caption',
                    ),
                    onChanged: (input) => _caption = input,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}