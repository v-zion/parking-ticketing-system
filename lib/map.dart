import 'package:flutter/material.dart';
import 'session.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:convert';
import 'parkinfo.dart';


class MapPage extends StatefulWidget{
  @override
  MapPageState createState() => new MapPageState();
}

class MapPageState extends State<MapPage>{

  bool _loaded = false;
  bool _location_on = true;
  List<Marker> _markers = <Marker>[];

  @override
  Widget build(BuildContext context){
    return
    new Expanded(
      flex: 6,
      child: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(Session.latitude, Session.longitude),
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
    );
  }

  @override
  void initState(){
    super.initState();
    _markers.add(new Marker(
      width: 40.0,
      height: 40.0,
      point: new LatLng(Session.latitude, Session.longitude),
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
        + Session.latitude.toString() + "&longitude=" + Session.longitude.toString());
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParkInfoAll(d)),
                  );
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

}
