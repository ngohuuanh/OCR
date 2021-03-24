import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:ocr/widgets/provider_widget.dart';

class MapView extends StatefulWidget {
  final String url;
  final double lat, lng;
  final int id;

  MapView({Key key, @required this.lat, this.lng, this.url, this.id})
      : super(key: key);

  @override
  _MapViewState createState() => _MapViewState(lat, lng, url, id);
}

class _MapViewState extends State<MapView> {
  GoogleMapController _controller;
  final String url;
  final double lat, lng;
  final int id;

  _MapViewState(this.lat, this.lng, this.url, this.id);
  Map<MarkerId, Marker> _markers = Map<MarkerId, Marker>();
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(10.7720817, 106.675066));
  MapType _defaultMapType = MapType.normal;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      //_isMapCreated = true;
      if (widget.lat != null && widget.lat > 0.1) {
        drawMarker(LatLng(lat, lng));
      }
    });
  }

  void drawMarker(LatLng _latLn) {
    final MarkerId markerId = MarkerId('1');
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        _latLn.latitude,
        _latLn.longitude,
      ),
    );

    setState(() {
      _markers[markerId] = marker;
    });
    if (_controller != null)
      _controller.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _latLn, zoom: 14)));
  }

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FutureBuilder(
            future: Provider.of(context).auth.getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.isAnonymous != true) {
                  if (id == null) {
                    return IconButton(
                        icon: Icon(Icons.save_alt_outlined),
                        onPressed: () async {
                          var message = await _createUrlInfo(url, lat, lng);
                          _showMaterialDialog(message);
                        });
                  } else {
                    return IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    );
                  }
                } else {
                  return IconButton(
                    icon: Icon(Icons.login),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/convertUser');
                    },
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
            },
          )
        ],
        title: Text('Google Map'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.of(_markers.values),
            mapType: _defaultMapType,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
          ),
          Container(
            margin: EdgeInsets.only(top: 80, right: 10),
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                    child: Icon(Icons.layers),
                    elevation: 5,
                    backgroundColor: Colors.teal[200],
                    onPressed: () {
                      _changeMapType();
                    }),
              ],
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          )
        ],
      ),
    );
  }

  _createUrlInfo(String url, double lat, double long) async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    Response response = await post(
      'http://10.0.2.2:4000/url/add',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'uid': uid, 'url': url, 'lat': lat, 'long': lng}),
    );

    return jsonDecode(response.body);
  }

  _showMaterialDialog(var message) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("${message['message']}"),
              content: new Text("You just saved it!"),
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
