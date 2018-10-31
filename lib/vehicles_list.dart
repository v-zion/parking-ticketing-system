import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';

class VehicleListPage extends StatefulWidget{
  @override
  VehicleListState createState() => new VehicleListState();
}

class VehicleListState extends State<VehicleListPage> {

  final session = new Session();
  bool _loaded = false;
  final List<Entry> _myCars = <Entry>[];

  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  Widget buildWidget(){
    if (_loaded){
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('My Vehicles'),
          ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                EntryItem(_myCars[index]),
            itemCount: _myCars.length,
          ),
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
          )
      );
    }
  }

  @override
  void initState(){
    super.initState();
    var getResponse = session.get(Session.url + 'VehiclesList?id=123');
    getResponse.then((response) {
      Map<String, dynamic> jsonResponse = json.decode(response);
      if (jsonResponse['status']) {
        for (Map<String, dynamic> d in jsonResponse['data']){
          _myCars.add(new Entry(d['cid'], d['uid'], d['location'], d['price'], d['start_time'], d['entry_time']));
        }
        setState(() {
          _loaded = true;
        });
      }
      else{

      }
    });
  }

}

class Entry extends StatefulWidget{
  Entry(this.cid, this.uid, this.location, this.price, this.startTime, this.entryTime);

  final String cid; // Car ID
  String uid; // Payer
  final String location;
  final String price;
  final String startTime;
  final String entryTime;

  EntryState createState() => new EntryState();
}

class EntryState extends State<Entry>{

  bool _expanded = false;

  @override
  Widget build(BuildContext context){
    if (widget.uid == null) return ListTile(title: Text(widget.cid));
    return ExpansionTile(
      key: PageStorageKey<Entry>(widget),
      title: Text(widget.cid),
      children: <ListTile>[
        ListTile(title: Text("Payer : " + widget.uid)),
        ListTile(title: Text("Location : " + widget.location)),
        ListTile(title: Text("Price : " + widget.price)),
        ListTile(title: Text("Parked from : " + widget.entryTime)),
      ],
    );
  }
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.uid == null) return ListTile(title: Text(root.cid));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.cid),
      children: <ListTile>[
        ListTile(title: Text("Payer : " + root.uid)),
        ListTile(title: Text("Location : " + root.location)),
        ListTile(title: Text("Price : " + root.price)),
        ListTile(title: Text("Parked from : " + root.entryTime)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}