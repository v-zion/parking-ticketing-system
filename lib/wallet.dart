import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'dart:async';
import 'home.dart';


class MyWallet extends StatefulWidget{
  @override
  MyWalletPage createState() {
    return MyWalletPage();
  }
}

class MyWalletPage extends State<MyWallet>{
  var outcome;
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
            MaterialPageRoute(builder: (context) => MyWallet()),
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
              title: const Text('Loading')
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
          ),

          drawer: drawit(context)
      );
    }

  }

}