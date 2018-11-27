import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'home.dart';
import 'police.dart';

class Notifications extends StatefulWidget{
//  var s;
//  CarDetail(t){
//    s=t;
//  }
  @override
  MyNotifications createState() {
    return MyNotifications();
  }
}

class MyNotifications extends State<Notifications>{
  var notifs;
  var outcome;
//  MyCarDetail(t){
//    s=t;
//  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Session login = new Session();
    login.get(login.getURL()+"FetchNotify").then((q){
      print(q);
      print("jhfhjm");
      if(json.decode(q)["status"]) {
        setState(() {
//        print(q);
          Session.bell=Icon(Icons.notifications_none);
          notifs = json.decode(q)['data'] as List;
          print(notifs);
          outcome = 1;
        });
      }
    });
  }

  Widget _buildListTile(u){
//    print(u);
    if(u["type"]=="1" && u["read"]==0){
//      print("hh");
      return new Container(
        color: const Color(0xFF00FF00),

        child: new ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: new Text("Car "+u["cid"]+" reported by policeman "+u["police_uid"]+". Contact nearest police-station or reach your car ASAP." ),
//          subtitle: new Text()
        )
      );
    }
    else if(u["type"]=="1"){
      return new Container(
        child: new ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: new Text("Car "+u["cid"]+" reported by policeman "+u["police_uid"]+". Contact nearest police-station or reach your car ASAP." ),
//          subtitle: new Text()
        )
      );
    }
    else if(u["read"]==0){
      return new Container(
        color: const Color(0xFF00FF00),
        child: new ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: new Text("Amount: "+u["balance"]+". Refill your balance." ),
//          subtitle: new Text()
        )
      );
    }
    else{
      return new Container(
        child: new ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: new Text("Amount:  "+u["balance"]+". Refill your balance." ),
//          subtitle: new Text()
        )
      );
    }
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
        drawer: drawit(context),
      );
    }
    else {
      return new Scaffold(
        appBar: AppBar(
            title: new Text("Notifications")
        ),
        body: new Builder(
          builder: (context) => new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Expanded(
                child: new ListView.builder(
                    itemCount: notifs.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return _buildListTile(notifs[index]);
                    }),
              ),
              new Container(
                  margin: const EdgeInsets.all(10.0),//new
                  decoration: new BoxDecoration(
                      color: Theme.of(context).cardColor),                  //new
                  child: new RaisedButton(
                    onPressed: (){
                      var session=new Session();
                      session.get(session.getURL() + 'ClearAll').then((response) {
                        var jsonResponse = json.decode(response);
                        print(jsonResponse);
                        if (jsonResponse['status']) {
                          Session login = new Session();
                          login.get(login.getURL()+"FetchNotify").then((q){
                            print(q);
                            print("jhfhjm");
                            if(json.decode(q)["status"]) {
                              setState(() {
                                notifs = json.decode(q)['data'] as List;
                                print(notifs);
                                outcome = 1;
                              });
                            }
                          });
                        }
                        else{
                          Scaffold.of(context).showSnackBar(
                              new SnackBar(
                                  content: Text("Unable to clear notifications. Please try again.")
                              )
                          );
                        }
                      });
                    },
                    child: Text('Clear all'),
                  )                       //modified
              ),
            ],
          ),
        ),
        drawer: drawit(context),

      );
    }

  }

}
