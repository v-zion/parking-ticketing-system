import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'cardetail.dart';

class PolicePage extends StatefulWidget {
  @override
  MyPolicePage createState() => new MyPolicePage();
}

class MyPolicePage extends State<PolicePage> {
  final _formKey = GlobalKey<FormState>();
  final CarController = new TextEditingController();

  final session = new Session();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Inspect Car ID'),
        ),
        body: new Builder(
          builder: (context) => new Form(
            key: _formKey,
            child: new Container(
                child: new Column(
                  children: <Widget>[

                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'CID'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Empty uid not allowed';
                        }
                      },
                      controller: CarController,
                    ),

                    new RaisedButton(
                      onPressed: (){
                        print(CarController.text);
                        if (_formKey.currentState.validate()){
                          session.get(session.getURL() + 'IfCarExist?cid=' + CarController.text).then((response) {
                            var jsonResponse = json.decode(response);
                            print(jsonResponse);
                            if (!jsonResponse['status']) {
                              Scaffold.of(context).showSnackBar(
                                  new SnackBar(
                                      content: Text(jsonResponse['message'])
                                  )
                              );
                            }
                            else{
                              Navigator.of(context).pushReplacement(new MaterialPageRoute<void>(builder: (BuildContext context) => new CarDetail(CarController.text)));
                            }
                          }).catchError((e) => print(e));

                        }
                      },
                      child: Text('Search'),
                    )
                  ],
                )
            ),
          ),
        ),
        drawer: CreateDrawer(context)
    );
  }



}
