import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'session.dart';
import 'dart:convert';
import 'dart:async';

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
                title: Text(suggestion["value"]),
                subtitle: Text(suggestion["label"]),
              );
            },
            onSuggestionSelected: (suggestion) {
//              _handleSubmitted(suggestion["value"]);
            },
          )
        ],
      ),

      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}