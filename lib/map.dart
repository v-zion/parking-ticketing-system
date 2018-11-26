import 'package:flutter/material.dart';
import 'session.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:convert';


class MapPage extends StatefulWidget{
  @override
  MapPageState createState() => new MapPageState();
}

class MapPageState extends State<MapPage>{

  Map<String, double> location;
  bool _loaded = false;
  bool _location_on = true;
  List<Marker> _markers = <Marker>[];

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
                      center: new LatLng(19.0, 73.0),
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
        _markers.add(new Marker(
          width: 40.0,
          height: 40.0,
          point: new LatLng(location['latitude'], location['longitude']),
          builder: (ctx) =>
          new Container(
            child: IconButton(
              icon: Icon(Icons.brightness_1),
              color: Colors.blue,
              iconSize: 15.0,
              onPressed: () {
                print('Marker tapped');
              },
            ),
          ),
        ));
        Session session = new Session();
        var getResponse = session.get(Session.url + "AutoCompleteUser?term=&latitude="
            + l['latitude'].toString() + "&longitude=" + l['longitude'].toString());
        getResponse.then((response){
          print(response);
          Map<String, dynamic> jsonResponse = json.decode(response);
          if (jsonResponse['status']) {
            for (var d in jsonResponse['data']){
              print(d);
              _markers.add(new Marker(
                width: 40.0,
                height: 40.0,
                point: new LatLng(double.parse(d['latitude']), double.parse(d['longitude'])),
                builder: (ctx) =>
                new Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: d['is_street'] == "0" ? Colors.red : Colors.green,
                    iconSize: 25.0,
                    onPressed: () {
                      print('Marker tapped');
                    },
                  ),
                ),
              )
              );
            }
            setState(() {
              _loaded = true;
            });
          }
          else{

          }
        });
      }
      else{
        _location_on = false;
      }
    });

  }

  MarkerLayerOptions markerList(){
    if (!_loaded){
      return new MarkerLayerOptions(
        markers: _markers,
      );
    }
    else{
      return new MarkerLayerOptions(
        markers: _markers,
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