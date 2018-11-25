import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'dart:async';
import 'vehicles_list.dart';


class CarInfo extends StatefulWidget{
  var s,f;
  CarInfo(st,ft){
    s=st;
    f=ft;
  }
  @override
  CarInfoAll createState() {
    return CarInfoAll(s,f);
  }
}

class CarInfoAll extends State<CarInfo>{
  var s,f,outcome;
  var cars;
  CarInfoAll(st,ft){
    s=st;
    f=ft;
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Session login = new Session();
    login.get(login.getURL()+"CarInfo").then((q){

      if(json.decode(q)["status"]) {
        setState(() {
//        print(q);
          cars = json.decode(q)['data'] as List;
          print(cars);
          outcome = 1;
        });
      }
    });
  }

  _handleSubmit(cid){
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text("Are you sure"),
        content: new Text("Car: "+cid+"\nLocation: "+s["value"]+"\nFloor: "+f),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(context), child: Text('No'),),
          FlatButton(onPressed: () => _reallyPark(cid, context), child: Text('Yes'),),
        ],
      ),
    );
  }
  _reallyPark(cid, local_context){
    Session login=new Session();
    Map<String, String> postData = new Map<String, String>();
    postData['cid'] = cid;
    postData['pid'] = s["label"];
    postData['floor'] = f;

    login.post(login.getURL()+"ParkHere",postData).then((s){
      print(s);
      var temp=json.decode(s);
      if(temp["status"]){

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VehicleListPage()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    if(outcome==null){
      return new Scaffold(
        appBar: new AppBar(
            title: const Text('Select Car')
        ),
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
    }
    else {
      return new Scaffold(
        appBar: AppBar(
            title: const Text('Select Car')
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Expanded(
              child: new ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (BuildContext context, int index)
                  {
                    return new ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      title: new Text(cars[index]["cid"]),
//                  trailing: new Text(floors[index]["free_space"].toString()),
                      enabled: true,
                      onTap: () {
                        _handleSubmit(cars[index]["cid"]);
                      },
                    );
                  }),
            ),
          ],
        ),

      );
    }

  }

}
