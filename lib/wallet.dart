import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'dart:async';
import 'home.dart';
import 'main.dart';
import 'OwnersPage.dart';
import 'notifications.dart';


class MyWallet extends StatefulWidget{
  var type;
  MyWallet(t){
    type=t;
  }
  @override
  MyWalletPage createState() {
    return MyWalletPage(type);
  }
}

class MyWalletPage extends State<MyWallet>{
  var outcome;
  var type;
  MyWalletPage(t){
    type=t;
  }
  var session=new Session();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Session login = new Session();
    login.get(login.getURL()+"DisplayMoney").then((amount){
      setState(() {
        print(amount);
        outcome=amount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final message = new TextEditingController();

    void _handleSubmitted(String text) {
      Session login = new Session();
      login.get(login.getURL()+"UpdateMoney?amount="+text).then((s){
        if(json.decode(s)["status"])
        {
          print(s);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyWallet(type)),
          );
        }

      });
      message.clear();
    }

    Widget _buildTextComposer() {
      return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: message,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                    hintText: "Add amount"),
              ),
            ),
            new Container(                                                 //new
              margin: new EdgeInsets.symmetric(horizontal: 4.0),           //new
              child: new IconButton(                                       //new
                  icon: new Icon(Icons.send),                                //new
                  onPressed: () => _handleSubmitted(message.text)),  //new
            ),                                                             //new
          ],
        ),
      );
    }

    if(outcome==null){
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
          drawer: drawit(context)
      );
    }
    else {
      var amount= json.decode(outcome)["data"][0]["amount"];
      print(amount);
      return new Scaffold(
          appBar: AppBar(
            title: const Text('My Wallet'),
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
          body: new Column(
            children: <Widget>[
              new Text(amount, style: TextStyle(fontSize: 60.0),),
              new Container(
                margin: const EdgeInsets.all(10.0),//new
                decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor),                  //new
                child: _buildTextComposer(),                       //modified
              ),
            ],
          ),

          drawer: type==0 ? drawit(context): drawfit(context)
      );
    }

  }

  Widget drawfit(BuildContext context){
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
            title: Text('Home'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OwnersPage()),
              );
            },
          ),


          ListTile(
            title: Text('Passbook'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyWallet(1)),
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

}