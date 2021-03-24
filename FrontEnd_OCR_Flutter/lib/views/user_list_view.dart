import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users list"),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getAllUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                    itemCount: (snapshot.data).length,
                    itemBuilder: (context, index) {
                      return buildDismissible(snapshot, index);
                    },
                  );
                } else {
                  return Container(
                    child: Text("No Users data"),
                  );
                }
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
            }),
      ),
    );
  }

  buildDismissible(AsyncSnapshot snapshot, int index) {
    return Dismissible(
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
        color: Colors.red,
      ),
      key: Key(
        snapshot.data[index]['name'],
      ),
      onDismissed: (direction) {
        //call api
        _removeUser(snapshot, index);
        snapshot.data.removeAt(index);
        //setState(() {});
      },
      child: Card(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 0.0, top: 8.0, bottom: 8.0),
                child: Icon(Icons.account_circle, size: 50),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                child: Container(
                  width: 250.0,
                  child: Text(
                    "${snapshot.data[index]['name']}",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showMaterialDialog(snapshot, index);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
                  child: Icon(Icons.info_outline_rounded, size: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getAllUser() async {
    Response response = await get(
      'http://10.0.2.2:4000/user/getall',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user');
    }
  }

  _removeUser(AsyncSnapshot snapshot, int index) async {
    var uid = snapshot.data[index]['id_user'];
    Response response = await delete(
      'http://10.0.2.2:4000/user/del/$uid',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete user');
    }
  }

  _showMaterialDialog(AsyncSnapshot snapshot, int index) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.all(8.0),
              title: new Text("Info User"),
              content: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  height: 90.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text(
                        "ID: ${snapshot.data[index]["id"]}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                      new Text(
                        "Name: ${snapshot.data[index]["name"]}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                      new Text(
                        "UID: ${snapshot.data[index]["id_user"]}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                      new Text(
                        "Role: ${snapshot.data[index]["role"]}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
