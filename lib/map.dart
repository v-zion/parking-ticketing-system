import 'package:flutter/material.dart';
import 'session.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';


class MapPage extends StatefulWidget{
  @override
  MapPageState createState() => new MapPageState();
}

class MapPageState extends State<MapPage>{

  Map<String, double> location;
  bool _loaded = false;
  bool _location_on = true;

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(title: Text('Map'),),
      body: Container(
        child: 
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: _loaded ? new Text('Loaded'): new Text(''), flex: 1),
              new Expanded(
                flex: 10,
                child: new FlutterMap(
                  options: new MapOptions(
                    center: new LatLng(51.5, -0.09),
                    zoom: 13.0,
                  ),
                  layers: [
                    new TileLayerOptions(
                      urlTemplate: "https://api.tiles.mapbox.com/v4/"
                          "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                      additionalOptions: {
                        'accessToken': 'pk.eyJ1IjoiYW5pYm9oYXJhIiwiYSI6ImNqb3d4dDA4cTFudHMzc3BqdWpvajF6ODQifQ.aw1WVgen0LBT5FSWyr9k5g',
                        'id': 'mapbox.streets',
                      },
                    ),
                    markerList()
                  ],
        ),
              ),
            ],
          )
      )
    );
  }

  @override
  void initState(){
    super.initState();
    getLocation().then((Map<String, double> l) {
      print(l);
      if (l != null) {
        location = l;
      _loaded = true;
      }
      else{
        _location_on = false;
      }
    });
  }

  MarkerLayerOptions markerList(){
    if (!_loaded){
      return new MarkerLayerOptions(
        markers: [
          new Marker(
            width: 80.0,
            height: 80.0,
            point: new LatLng(51.5, -0.09),
            builder: (ctx) =>
            new Container(
              child: IconButton(
                icon: Icon(Icons.location_on),
                color: Colors.red,
                iconSize: 45.0,
                onPressed: () {
                  print('Marker tapped');
                },
              ),
            ),
          ),
        ],
      );
    }
    else{
      new MarkerLayerOptions(
        markers: [
          new Marker(
            width: 80.0,
            height: 80.0,
            point: new LatLng(51.5, -0.09),
            builder: (ctx) =>
            new Container(
              child: IconButton(
                icon: Icon(Icons.location_on),
                color: Colors.red,
                iconSize: 45.0,
                onPressed: () {
                  print('Marker tapped');
                },
              ),
            ),
          ),
          new Marker(
            width: 80.0,
            height: 80.0,
            point: new LatLng(location['latitude'], location['longitude']),
            builder: (ctx) =>
            new Container(
              child: IconButton(
                icon: Icon(Icons.circle),
                color: Colors.blue,
                iconSize: 25.0,
                onPressed: () {
                  print('Marker tapped');
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  Future<Map<String, double> > getLocation() async {
    var currentLocation = <String, double>{};
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception{
      currentLocation = null;
    }
    return currentLocation;
  }

}