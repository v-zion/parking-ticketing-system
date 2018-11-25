import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'home.dart';
import 'main.dart';


class RegisterUser extends StatefulWidget {
  @override
  RegisterUserState createState() => new RegisterUserState();
}

class RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final uidController = new TextEditingController();
  final phoneController = new TextEditingController();
  final classController = new TextEditingController();


  final session = new Session();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Register User'),
        ),
        body: new Builder(
          builder: (context) => new Form(
            key: _formKey,
            child: new Container(
                child: new Column(
                  children: <Widget>[

                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'uid'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Empty uid not allowed';
                        }
                      },
                      controller: uidController,
                    ),

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
                          labelText: 'Phone'
                      ),
                      controller: phoneController,
                    ),

                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'Class'
                      ),
                      controller: classController,
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
                          postData['uid'] = uidController.text;
                          postData['name']=usernameController.text;
                          postData['password'] = passwordController.text;
                          postData['phone']= phoneController.text;
                          postData['class']=classController.text;
                          var postResponse = session.post(session.getURL() + 'RegisterUser', postData);
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

                              Map<String, String> myData = new Map<String, String>();
                              myData['userid'] = postData['uid'];
                              myData['password'] = postData['password'];

                              var myResponse = session.post(session.getURL() + 'LoginServlet', myData);

                              myResponse.then((response) {
                                Map<String, dynamic> jsonResponse = json.decode(response);
                                print(response);
                                if (!jsonResponse['status']) {
                                  Navigator.of(context).pushReplacement(new MaterialPageRoute<void>(builder: (BuildContext context) => new LoginForm()));
                                }
                                else{
                                  session.uid=postData['userid'];
                                  Navigator.of(context).pushReplacement(new MaterialPageRoute<void>(builder: (BuildContext context) => new SearchSite()));
                                }
                              });
                            }
                          }).catchError((e) => print(e));

                        }
                      },
                      child: Text('Submit'),
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