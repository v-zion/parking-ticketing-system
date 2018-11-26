import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'session.dart';
import 'dart:convert';
import 'dart:async';
import 'main.dart';
import 'wallet.dart';
import 'vehicles_list.dart';
import 'parkinfo.dart';
import 'MakeOwner.dart';
import 'map.dart';
import 'qrScanner.dart';
import 'qrGenerator.dart';
import 'package:location/location.dart';

class SearchSite extends StatefulWidget{
  @override
  MySearchPage createState() {
    return MySearchPage();
  }
}

class MySearchPage extends State<SearchSite> {
  final String title="PVC";
  bool _loaded = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation().then((Map<String, double> l) {
      print(l);
      if (l != null) {
        Session.latitude = l['latitude'];
        Session.longitude = l['longitude'];
        setState(() {
          _loaded = true;
        });
      }
      else{

      }
    });

  }

  _handleSubmitted(s){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ParkInfoAll(s)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded){
      return new Scaffold(
        appBar: new AppBar(
            title: const Text('Loading')
        ),
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
        drawer: drawit(context),
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: new Column(
            children: <Widget>[

              Container(
                padding: EdgeInsets.all(5.0),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    //                  style: DefaultTextStyle.of(context).style.copyWith(
                    //                      fontStyle: FontStyle.normal
                    //                  ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search'
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    Session login = new Session();
                    return await login.get(
                        login.getURL() + "AutoCompleteUser?latitude=" + Session.latitude.toString()
                            + "&longitude=" + Session.longitude.toString() + "&term=" + pattern)
                        .then((t) {
                      var p = json.decode(t);
                      print(p);
                      return p;
                    });
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion["label"]),
                      subtitle: Text(suggestion["value"]),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _handleSubmitted(suggestion);
                  },
                ),
              ),
              new MapPage(),
            ],
          ),

          drawer: drawit(context)
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

Widget drawit(BuildContext context){
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the Drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('PVC'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Passbook'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyWallet()),
            );
          },
        ),
        ListTile(
          title: Text('Search'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchSite()),
            );
          },
        ),
        ListTile(
          title: Text('Scan QR Code'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ScanScreen()),
            );
          },
        ),
        ListTile(
          title: Text('Generate QR Code'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GenerateScreen()),
            );
          },
        ),
        ListTile(
          title: Text('My Vehicles'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => VehicleListPage()),
            );
          },
        ),
        ListTile(
          title: Text('Own a car'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MakeOwner()),
            );
          },
        ),

        //////////////////



        ListTile(
          title: Text('Logout'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Session login=new Session();
            login.get(login.getURL()+"LogoutServlet").then((t){
              var p=json.decode(t);
              if(p["status"]){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginForm()),
                );
              }
            });
          },
        ),
      ],
    ),
  );
}
