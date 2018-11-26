import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'main.dart';
import 'police.dart';

class CarDetail extends StatefulWidget{
  var s;
  CarDetail(t){
    s=t;
  }
  @override
  MyCarDetail createState() {
    return MyCarDetail(s);
  }
}

class MyCarDetail extends State<CarDetail>{
  var s,outcome;
  var owners;
  MyCarDetail(t){
    s=t;
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Session login = new Session();
    print(s);
    login.get(login.getURL()+"MainCarInfo?cid="+s).then((q){
      print(q);
      print("jhfhjm");
      if(json.decode(q)["status"]) {
        setState(() {
//        print(q);
          owners = json.decode(q)['data'] as List;
          print(owners);
          outcome = 1;
        });
      }
    });
  }

  Widget _buildListTile(u){
//    print(u);
    if(u["ifparked"]==1){
//      print("hh");
      return new ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: new Text(u["name"]),
        trailing: Icon(Icons.directions_car),
        subtitle: new Row(
            children: <Widget>[
              Expanded(
                child: Text(u["uid"], textAlign: TextAlign.left),
              ),
              Expanded(
                child: Text(u["phone"], textAlign: TextAlign.right),
              )
            ]
        )
      );
    }
    else{
//      print("hjvh");
      return new ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: new Text(u["name"]),
          subtitle: new Row(
              children: <Widget>[
                Expanded(
                  child: Text(u["uid"], textAlign: TextAlign.left),
                ),
                Expanded(
                  child: Text(u["phone"], textAlign: TextAlign.right),
                )
              ]
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
      );
    }
    else {
      return new Scaffold(
        appBar: AppBar(
            title: new Text(s)
        ),
        body: new Builder(
          builder: (context) => new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Expanded(
                child: new ListView.builder(
                    itemCount: owners.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return _buildListTile(owners[index]);
                    }),
              ),
              new Container(
                margin: const EdgeInsets.all(10.0),//new
                decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor),                  //new
                child: new RaisedButton(
                  onPressed: (){
                    var session=new Session();
                    Map<String, String> postData = new Map<String, String>();
                    postData['cid'] = s;
                    postData['inspector_uid'] = session.uid;
                    session.post(session.getURL() + 'Notify',postData).then((response) {
                      var jsonResponse = json.decode(response);
                      print(jsonResponse);
                      if (jsonResponse['status']) {
                        Scaffold.of(context).showSnackBar(
                            new SnackBar(
                                content: Text("Sent Message Successfully")
                            )
                        );
                      }
                      else{
                        Scaffold.of(context).showSnackBar(
                            new SnackBar(
                                content: Text("Unable to send message. Please try again.")
                            )
                        );
                      }
                    });
                  },
                  child: Text('Notify the owners.'),
                )                       //modified
              ),
            ],
          ),
        ),
        drawer: CreateDrawer(context),

      );
    }

  }

}


Widget CreateDrawer(BuildContext context){
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
          title: Text('Search'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PolicePage()),
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
