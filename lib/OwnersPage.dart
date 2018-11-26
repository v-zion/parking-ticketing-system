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
import 'home.dart';

class OwnersPage extends StatefulWidget{
  @override
  OwnersPageState createState() {
    return OwnersPageState();
  }
}

class OwnersPageState extends State<OwnersPage> {

  final session = new Session();
  bool _loaded = false;
  final List<Entry> _myParkingMalls = <Entry>[];
  final List<tempEntry> _mytempParkingMalls = <tempEntry>[];

  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  Widget buildWidget(){
    if (_loaded){
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('My Parking Malls'),
          ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index){
              print(index);
              print(_myParkingMalls[index]);
              return _myParkingMalls[index];
            },
            itemCount: _myParkingMalls.length,
          ),
          drawer: drawit(context),
        ),
      );
    }
    else{
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
  }

  @override
  void initState(){
    super.initState();
    var getResponse = session.get(Session.url + 'ParkingMallsList');
    getResponse.then((response) {
      print(response);
      Map<String, dynamic> jsonResponse = json.decode(response);
      if (jsonResponse['status']) {
        for (Map<String, dynamic> d in jsonResponse['data']){
          _mytempParkingMalls.add(new tempEntry(d['pid'], d['uid'], d['latitude'], d['longitude'],
              d['price'], d['name'], d['floor_number'], d['total_space'], d['free_space']));
        }


        var index=-1;
        for (Map<String, dynamic> d in jsonResponse['data']){
          if(!_myParkingMalls.isEmpty && d['pid']== _myParkingMalls[index].pid) {
            print(index);
            continue;
          }
          index =index+1;
          _myParkingMalls.add(new Entry(d['pid'], d['uid'], d['latitude'], d['longitude'],
              d['price'], d['name'], d['floor_number'], d['total_space'], d['free_space'], _mytempParkingMalls));
        }

        print(_myParkingMalls);
        print(_myParkingMalls.length);
        setState(() {
          _loaded = true;
        });
      }
      else{

      }
    });
  }

}

class tempEntry{
  tempEntry(this.pid, this.uid, this.latitude, this.longitude, this.price, this.name,
      this.floor_number, this.total_space, this.free_space);

  final String pid; // Parking ID
  String uid; // Owner
  final String latitude;
  final String longitude;
  final String price;
  final String name;
  final String floor_number;
  final String total_space;
  final String free_space;

}


class Entry extends StatefulWidget{
  Entry(this.pid, this.uid, this.latitude, this.longitude, this.price, this.name,
      this.floor_number, this.total_space, this.free_space, this.mytempParkingMalls);

  final String pid; // Parking ID
  String uid; // Owner
  final String latitude;
  final String longitude;
  final String price;
  final String name;
  final String floor_number;
  final String total_space;
  final String free_space;
  List<tempEntry> mytempParkingMalls;

  EntryState createState() => new EntryState();
}

class EntryState extends State<Entry>{

  @override
  Widget build(BuildContext context){
    Session session = new Session();

    if (widget.uid == null) return ListTile(title: Text(widget.uid));
    return ExpansionTile(
      key: PageStorageKey<Entry>(widget),
      title: Text(widget.name),
      children: createlist(widget.price, widget.pid, widget.mytempParkingMalls),
    );
  }

  List<ListTile> createlist(price, pid , List<tempEntry> mytempParkingMalls){
      print("hello");
      List<ListTile> temp = <ListTile>[];
        for(var x in mytempParkingMalls)
        {
          print(x.pid);
          print(x.floor_number);
          print(x.total_space);
          print(x.free_space);
          if(x.pid == pid)
            {
              temp.add(new ListTile(title: Text("Floor number : " + x.floor_number),
                  trailing: Text(x.free_space+ "/" + x.total_space)));
            }
        }
        temp.add(new ListTile(title: Text("Price : " + price)));
        temp.add(new ListTile(title: Text("Contact Eashan Gupta")));
        return temp;
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
