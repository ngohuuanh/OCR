import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ocr/views/map_view.dart';
import 'package:ocr/widgets/provider_widget.dart';
import 'package:ocr/views/image_view.dart';

class PastView extends StatefulWidget {
  @override
  _PastViewState createState() => _PastViewState();
}

class _PastViewState extends State<PastView> {
  final primaryColor = const Color(0xFF75A2EA);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: Provider.of(context).auth.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.isAnonymous != true) {
              return displayImageList(context, snapshot);
            } else {
              return Center(
                child: Text(
                  "You aren't a member",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400),
                ),
              );
            }
          } else {
            return buildWaitingCheckMember();
          }
        },
      ),
    );
  }

  buildWaitingCheckMember() {
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
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Checking member",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  displayImageList(context, snapshot) {
    return FutureBuilder(
      future: _getImageUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data['rowCount'] != 0) {
            return ListView.builder(
              itemCount: snapshot.data['rowCount'],
              itemBuilder: (BuildContext context, int index) {
                return buildListCardImage(context, snapshot, index);
              },
            );
          } else {
            return Center(
              child: Text('User has no data'),
            );
          }
        } else {
          return buildWaitingCheckConnectServer();
        }
      },
    );
  }

  buildWaitingCheckConnectServer() {
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
          Text(
            " Trying Connect to Server",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  buildListCardImage(BuildContext context, AsyncSnapshot snapshot, int index) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 0.1, bottom: 0.1, left: 0.3, right: 0.3),
      child: Dismissible(
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.0),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        key: Key('${snapshot.data['rows'][index]['id_url']}'),
        onDismissed: (direction) {
          //call api
          _removeUrl(snapshot, index);
          snapshot.data['rows'].removeAt(index);
        },
        child: Card(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //image
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageView(
                                link: snapshot.data['rows'][index]['link'])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 1.5, bottom: 1.5, left: 1.0, right: 4.0),
                    child: Container(
                      width: 120,
                      height: 120,
                      child:
                          Image.network(snapshot.data['rows'][index]['link']),
                    ),
                  ),
                ),

                //info lat - long
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          'Lat: ${snapshot.data['rows'][index]['lat']}',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          'Lng: ${snapshot.data['rows'][index]['long']}',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                //2 new feature
                Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () async {
                          //show dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Center(
                              child: Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                                child: CircularProgressIndicator(
                                  strokeWidth: 4.0,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue),
                                ),
                              ),
                            ),
                          );
                          //  API Process AI here  
                          var toado = await _processImage(
                              snapshot.data['rows'][index]['link']);
                          var id = await snapshot.data['rows'][index]['id_url'];
                          var _newlat = toado['lat'];
                          var _newlng = toado['lng'];

                          await _updateUrlInfo(id, _newlat, _newlng);
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        icon: Icon(Icons.replay_rounded),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapView(
                                        lat: snapshot.data['rows'][index]
                                            ['lat'],
                                        lng: snapshot.data['rows'][index]
                                            ['long'],
                                        url: null,
                                        id: snapshot.data['rows'][index]
                                            ['id_url'])));
                          },
                          icon: Icon(Icons.map_rounded)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//api lay img
  _getImageUserData() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    Response response = await get(
      'http://10.0.2.2:4000/url/img/$uid',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

// remove url
  _removeUrl(AsyncSnapshot snapshot, int index) async {
    var id = snapshot.data['rows'][index]['id_url'];
    Response response = await delete(
      'http://10.0.2.2:4000/url/del/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete url');
    }
  }

  //api update url
  _updateUrlInfo(int id, double lat, double lng) async {
    Response response = await put(
      'http://10.0.2.2:4000/url/update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id, 'lat': lat, 'long': lng}),
    );
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
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
