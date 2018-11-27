import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'home.dart';
import 'notifications.dart';


class MakeOwner extends StatefulWidget {
  @override
  MakeOwnerState createState() => new MakeOwnerState();
}

class MakeOwnerState extends State<MakeOwner> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = new TextEditingController();
  final uidController = new TextEditingController();


  var session = new Session();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Text('Own a car'),
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
        body: new Builder(
          builder: (context) =>  new Column(
            children: <Widget>[
              new Expanded(
                child: new Form(
                  key: _formKey,
                  child: new Container(
                      child: new Column(
                        children: <Widget>[

                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: 'cid'
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Empty cid not allowed';
                              }
                            },
                            controller: uidController,
                          ),



                          new TextFormField(
                            decoration: new InputDecoration(
                                labelText: 'Password'
                            ),
                            controller: passwordController,
                          ),

                          new RaisedButton(
                            onPressed: (){
                              if (_formKey.currentState.validate()){
                                Map<String, String> postData = new Map<String, String>();
                                postData['cid'] = uidController.text;
                                postData['password'] = passwordController.text;
                                var postResponse = session.post(session.getURL() + 'MakeOwner', postData);
                                //                        Scaffold.of(context).showSnackBar(
                                //                          new SnackBar(content: Text('Please wait'))
                                //                        );
                                postResponse.then((response) {
                                  Map<String, dynamic> jsonResponse = json.decode(response);
                                  if (!jsonResponse['status']) {
                                    Scaffold.of(context).showSnackBar(
                                        new SnackBar(
                                            content: Text(jsonResponse['message'])
                                        )
                                    );
                                  }
                                  else{
                                    Navigator.of(context).pushReplacement(new MaterialPageRoute<void>(builder: (BuildContext context) => new SearchSite()));
                                  }
                                }).catchError((e) => print(e));

                              }
                            },
                            child: Text('Submit'),
                          ),

                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ),

        drawer: drawit(context)
    );
  }

  @override
  void dispose(){
    uidController.dispose();
    passwordController.dispose();
    super.dispose();
  }


}