import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr/views/show_img_view.dart';
import 'package:ocr/widgets/provider_widget.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final primaryColor = const Color(0xFF75A2EA);
  File _imageFile;
  String _imageUrl;
  var usr;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: Provider.of(context).auth.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return buildHome(context, snapshot);
                } else {
                  return Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.all(5),
                      child: CircularProgressIndicator(
                        strokeWidth: 4.0,
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildHome(context, snapshot) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Container(
      height: _height,
      width: _width,
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: _height * 0.2),
            AutoSizeText(
              "Welcome ${(snapshot.data).displayName ?? 'Anonymous'}",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: _height * 0.01),
            AutoSizeText(
              "Please pick image",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: _height * 0.05),
            RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    "Choose Image",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onPressed: () {
                  _handleClickMe();
                }),
          ],
        ),
      ),
    );
  }

//show choice cam or gallery
  _handleClickMe() {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return buildCupertinoActionSheet(context);
        });
  }

  buildCupertinoActionSheet(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
            onPressed: () async {
              
              await _galPick();

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ShowImgView(url: _imageUrl, img: _imageFile)),
              );
            },
            child: Text('Gallery')),
        CupertinoActionSheetAction(
            onPressed: () async {
              
              await _camPick();
             
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ShowImgView(url: _imageUrl, img: _imageFile)),
              );
            },
            child: Text('Camera')),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancle'),
        onPressed: () => {Navigator.pop(context, 'Cancle')},
      ),
    );
  }

  _galPick() async {
    var pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      // maxWidth: 1920,
      // maxHeight: 1200,
      // imageQuality: 80,
    );
    _imageFile = File(pickedFile.path);
    

    await _upImg();
    
  }

  _camPick() async {
    var pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      // maxWidth: 1920,
      // maxHeight: 1200,
      // imageQuality: 80,
    );
    _imageFile = File(pickedFile.path);
    
    await _upImg();
   
  }

  _upImg() async {
    Reference ref = FirebaseStorage.instance.ref().child("${DateTime.now()}");
    await ref.putFile(_imageFile);
    _imageUrl = await ref.getDownloadURL();
    print('URL Image: $_imageUrl');
    return _imageUrl;
  }
}
