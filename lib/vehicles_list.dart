import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'home.dart';
import 'notifications.dart';

class VehicleListPage extends StatefulWidget{
  @override
  VehicleListState createState() => new VehicleListState();
}

class VehicleListState extends State<VehicleListPage> {

  var session = new Session();
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
              actions: <Widget>[
                new IconButton(
                    icon: Session.bell,
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Notifications()),
                      );
                    }
                )
              ]
          ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index){
              print(index);
              print(_myCars[index]);
              return _myCars[index];
            },
            itemCount: _myCars.length,
          ),
          drawer: drawit(context),
        ),
      );
    }
    else{
      return new Scaffold(
          appBar: new AppBar(
              title: const Text('Loading'),
              actions: <Widget>[
                new IconButton(
                    icon: Session.bell,
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Notifications()),
                      );
                    }
                )
              ]
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
    var getResponse = session.get(Session.url + 'VehiclesList');
    getResponse.then((response) {
      print(response);
      Map<String, dynamic> jsonResponse = json.decode(response);
      if (jsonResponse['status']) {
        for (Map<String, dynamic> d in jsonResponse['data']){
          _myCars.add(new Entry(d['cid'], d['uid'], d['parking_name'], d['price'], d['start_time'], d['entry_time'], d['pname']));
        }
        print(_myCars);
        print(_myCars.length);
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
  Entry(this.cid, this.uid, this.parking_name, this.price, this.startTime, this.entryTime, this.name);

  final String cid; // Car ID
  String uid; // Payer
  final String parking_name;
  final String price;
  final String startTime;
  final String entryTime;
  final String name;

  EntryState createState() => new EntryState();
}

class EntryState extends State<Entry>{

  bool _imPaying = false;

  @override
  Widget build(BuildContext context){
    print(widget.parking_name);
    Session session = new Session();
    if (widget.uid == session.uid){
      _imPaying = true;
    }
    else{
      _imPaying = false;
    }
    print(widget.uid);
    print(session.uid);
    if (widget.uid == null) return ListTile(title: Text(widget.cid));
    return ExpansionTile(
      key: PageStorageKey<Entry>(widget),
      title: Text(widget.cid),
      children: <ListTile>[
        _imPaying ? ListTile(title: Text("Payer : You"),
          trailing: RaisedButton(child: Text("EXIT"), onPressed: () => _exitPark(widget.cid)),
        ) : ListTile(title: Text("Payer : " + widget.name),
          trailing: RaisedButton(child: Text("PAY"), onPressed: () => _changePayer(widget.cid)),),
        ListTile(title: Text("Parking name : " + widget.parking_name)),
        ListTile(title: Text("Price : " + widget.price)),
        ListTile(title: Text("Parked from : " + widget.entryTime)),
      ],
      trailing: Icon(Icons.directions_car, color: _imPaying ? Colors.red : Colors.green,),
    );
  }

  void _changePayer(String cid){
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text("Are you sure"),
        content: new Text("Do you really want to start paying for this car?"),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(context), child: Text('No'),),
          FlatButton(onPressed: () => _reallyChangePayer(cid, context), child: Text('Yes'),),
        ],
      ),
    );
  }

  void _reallyChangePayer(String cid, BuildContext local_context){
    Session session = new Session();
    Map<String, String> postData = Map<String, String>();
    postData['cid'] = cid;
    var getResponse = session.post(Session.url + "ChangePayer", postData);
    getResponse.then((response) {
      print(response);
      Map<String, dynamic> jsonResponse = json.decode(response);
      if (jsonResponse['status']) {
        Navigator.pop(local_context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VehicleListPage()));
      }
      else{

      }
    });
  }

  void _exitPark(String cid){
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text("Are you sure"),
        content: new Text("Do you really want to exit this car from parking?"),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(context), child: Text('No'),),
          FlatButton(onPressed: () => _reallyExit(cid, context), child: Text('Yes'),),
        ],
      ),
    );
  }

  void _reallyExit(String cid, BuildContext local_context){
    Session session = new Session();
    Map<String, String> postData = Map<String, String>();
    postData['cid'] = cid;
    var getResponse = session.post(Session.url + "ExitParking", postData);
    getResponse.then((response) {
      print(response);
      Map<String, dynamic> jsonResponse = json.decode(response);
//      if (jsonResponse['status']) {
      Navigator.pop(local_context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VehicleListPage()));
//      }
//      else{

//      }
    });
  }
}