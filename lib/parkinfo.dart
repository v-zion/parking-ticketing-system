import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'dart:async';
import 'carinfo.dart';


class ParkInfoAll extends StatefulWidget{
  var s;
  ParkInfoAll(t){
    s=t;
  }
  @override
  ParkInfo createState() {
    return ParkInfo(s);
  }
}

class ParkInfo extends State<ParkInfoAll>{
  var s,outcome;
  var floors;
  ParkInfo(t){
    s=t;
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Session login = new Session();
    login.get(login.getURL()+"ParkInfo?pid="+s["label"]).then((q){
      if(json.decode(q)["status"]) {
        setState(() {
//        print(q);
          floors = json.decode(q)['data'] as List;
          print(floors);
          outcome = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(outcome==null){
      return new Scaffold(
          appBar: new AppBar(
              title: const Text('Loading')
          ),
          body: new Center(
            child: new CircularProgressIndicator(),
          ),
      );
    }
    else {
      return new Scaffold(
          appBar: AppBar(
              title: const Text('Select Floor')
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Expanded(
                child: new ListView.builder(
                    itemCount: floors.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return new ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        title: new Text(floors[index]["floor_number"]),
                        trailing: new Text(floors[index]["free_space"].toString()),
                        enabled: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CarInfo(s,floors[index]["floor_number"])),
                          );
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