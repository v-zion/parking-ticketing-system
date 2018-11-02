import 'package:flutter/material.dart';
import 'session.dart';

class UserReg extends StatefulWidget {
  @override
  UserRegState createState() => new UserRegState();
}

class UserRegState extends State<UserReg> {
  final session = new Session();
  final _formKey = GlobalKey<FormState>();
  final userIDController = new TextEditingController();
  final nameController = new TextEditingController();
  final phoneNumController = new TextEditingController();
  final userClassController = new TextEditingController();
  final amountController = new TextEditingController();

  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    if (!_loaded){
      return new Scaffold(
          appBar: new AppBar(
              title: const Text('Loading')
          ),
          body: new Center(
            child: new CircularProgressIndicator(),
          )
      );
    }
    else {
      return new Scaffold(
        appBar: new AppBar(
          title: const Text('User Registeration'),
        ),
        body: new Builder(
            builder: (context) => newForm(
              key: _formKey,
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'User ID'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Empty user ID not allowed';
                        }
                      },
                      controller: userIDController,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Name'
                      ),
                      controller: nameController,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Phone Number'
                      ),
                      keyboardType: TextInputType.phone,
                      controller: phoneNumController,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'User Type'
                      ),
                      keyboardType: TextInputType.number,
                      controller: userClassController,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Amount'
                      ),
                      keyboardType: TextInputType.number,
                      controller: amountController,
                    ),
                    new RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {

                          }
                        }
                    )
                  ],
                ),
              )
            )),
      ),
    }
  }
}