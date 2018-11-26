import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'home.dart';
import 'RegisterUser.dart';
import 'police.dart';
import 'map.dart';
import 'OwnersPage.dart';
//import 'PolicePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'WhatAsap';

    return MaterialApp(
      title: appTitle,
      home: LoginForm(),
//      home: MapPage(),
    );
  }
}



class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => new LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final session = new Session();
  final oneSec = const Duration(seconds:1);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login Page'),
        ),
        body: new Builder(
          builder: (context) => new Form(
            key: _formKey,
            child: new Container(
                child: new Column(
                  children: <Widget>[
                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'Username'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Empty username not allowed';
                        }
                      },
                      controller: usernameController,
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
                          postData['userid'] = usernameController.text;
                          postData['password'] = passwordController.text;
                          var postResponse = session.post(session.getURL() + 'LoginServlet', postData);
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
                              session.uid=postData['userid'];
                              if(jsonResponse['data'][0]['class']==1)
                              {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute<void>(builder: (
                                          BuildContext context) => new OwnersPage()));

                              }
                              else if(jsonResponse['data'][0]['class']==2)
                              {
                                Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute<void>(builder: (
                                        BuildContext context) => new PolicePage()));

                              }
                              else {
                                Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute<void>(builder: (
                                        BuildContext context) => new SearchSite()));
                              }
                            }
                          }).catchError((e) => print(e));

                        }
                      },
                      child: Text('Submit'),
                    ),


                    new RaisedButton(
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute<void>(builder: (BuildContext context) => new RegisterUser()));
                      },
                      child: Text('RegisterUser'),
                    )

                  ],
                )
            ),
          ),
        )
    );
  }

  @override
  void dispose(){
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }


}
