import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocr/widgets/provider_widget.dart';
import 'package:ocr/views/user_list_view.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final primaryColor = const Color(0xFF75A2EA);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: Provider.of(context).auth.getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return displayUserInformation(context, snapshot);
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Icon(Icons.account_circle, size: 100),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Name: ${authData.displayName ?? 'Anonymous'}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Email: ${authData.email ?? 'Anonymous'}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Created: ${DateFormat('MM/dd/yyyy').format(authData.metadata.creationTime)}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: _getCheckAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data['rowCount'] != 0) {
                      if (snapshot.data['rows'][0]['role'] == "2") {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserListView()),
                            );
                          },
                          child: Text("Membership: Admin",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        );
                      } else {
                        return Text("Membership: User",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold));
                      }
                    } else {
                      return Text("Status: not exist",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold));
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        showSignOut(context, authData.isAnonymous),
      ],
    );
  }

  // call api check admin
  _getCheckAdmin() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    Response response = await get(
      'http://10.0.2.2:4000/user/check/$uid',
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

  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return Column(
        children: [
          RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              "You want to SignUp ?",
              style: TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/convertUser');
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              "Quit",
              style: TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              try {
                Provider.of(context).auth.signOut();
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      );
    } else {
      return RaisedButton(
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Text(
          "Sign Out",
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          try {
            Provider.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }
}
