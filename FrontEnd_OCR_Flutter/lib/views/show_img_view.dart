import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ocr/views/map_view.dart';

final primaryColor = const Color(0xFF75A2EA);
final grayColor = const Color(0xFF939393);
final secondColor = const Color(0xFFFFFFFF);

const double padding = 10.0;

class ShowImgView extends StatelessWidget {
  final File img;
  final String url;

  ShowImgView({Key key, @required this.img, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OCR"),
      ),
      body: Stack(
        children: [
          Container(
            child: img != null
                ? Container(child: Image.file(img))
                : Container(child: Text("Image not found")),
          ),
          FutureBuilder(
            future: _processImage(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return buildProcessingAI(context, snapshot);
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.all(5),
                        child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text('Waiting for processing AI',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Container buildProcessingAI(BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Lat: ${(snapshot.data)['lat']} - Long:${(snapshot.data)['lng']}"),
              RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "View Map",
                      style: TextStyle(
                        color: secondColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapView(
                                url: url,
                                lat: (snapshot.data)['lat'],
                                lng: (snapshot.data)['lng'])));
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _processImage(String urlimg) async {
    // urlimg = urlimg.substring(8);
    Response res1 = await post(
      'http://10.0.2.2:5111/img',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"url": "${urlimg.substring(8)}"}),
    );
    print(res1.body);
    Response res2 = await get(
      'http://10.0.2.2:5111/api?url=${urlimg.substring(8)}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(res2.body);
  }
}
