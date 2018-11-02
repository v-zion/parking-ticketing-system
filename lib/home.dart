import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'session.dart';
import 'dart:convert';
import 'dart:async';
import 'main.dart';
import 'wallet.dart';
import 'vehicles_list.dart';
import 'parkinfo.dart';

class SearchSite extends StatefulWidget{
  @override
  MySearchPage createState() {
    return MySearchPage();
  }
}

class MySearchPage extends State<SearchSite> {
  final String title="PVC";
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _handleSubmitted(s){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ParkInfoAll(s)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: new Column(
        children: <Widget>[
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder()
                )
            ),
            suggestionsCallback: (pattern) async {
              Session login = new Session();
              return await login.get(login.getURL()+"AutoCompleteUser?term="+pattern).then((t){
                var p=json.decode(t);
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
          )
        ],
      ),

      drawer: drawit(context)
    );
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
          child: Text('Yo'),
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