import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'dart:async';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'pvc';

    return MaterialApp(
      title: appTitle,
      home: MyWallet("1234"),
    );
  }
}


class MyWallet extends StatefulWidget{
  var uid;
  MyWallet(s){
    uid=s;
  }
  @override
  MyWalletPage createState() {
    return MyWalletPage(uid);
  }
}

class MyWalletPage extends State<MyWallet>{
  var outcome;
  var uid;
  MyWalletPage(s){
    uid=s;
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Session login = new Session();
    login.get("http://192.168.31.90:8080/pvc_servlets/DisplayMoney").then((amount){
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
      login.get("http://192.168.2.16:8080/pvc_servlets/UpdateMoney?amount="+text).then((s){
        if(json.decode(s)["status"])
        {
          print(s);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyWallet(uid)),
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
        appBar: AppBar(
        ),
        body: new Text("Loading ..."),
      );
    }
    else {
      var amount= json.decode(outcome)["data"];
      return new Scaffold(
          appBar: AppBar(
          ),
          body: new Column(
            children: <Widget>[
              new Text(amount),
              new Container(
                margin: const EdgeInsets.all(10.0),//new
                decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor),                  //new
                child: _buildTextComposer(),                       //modified
              ),

            ],
          )

      );
    }

  }

}