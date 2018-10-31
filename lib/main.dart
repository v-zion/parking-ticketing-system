import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'PVC';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(),
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text(appTitle),
//        ),
//        body: MyHomePage(),
//      ),
    );
  }
}


class MyHomePage extends StatefulWidget{
  @override
  MyCustomHomePage createState() {
    return MyCustomHomePage();
  }
}

class MyCustomHomePage extends State<MyHomePage> {

  final appTitle = 'PVC';
  int state;

  @override
  void initState() {
    // TODO: implement initState
//    print("jer");
//    print(state);
//    print("jer");
    super.initState();
//    print("hello");
    Session login = new Session();
    login.get(login.getURL()+"LoginServlet").then((islogged){
      int temp;
      print(json.decode(islogged)["status"]);
      if(json.decode(islogged)["status"]) {
        temp = 1;
      }
      else{
        temp=0;
      }
      setState(() {
        state=temp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if(state==null){
      return new Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: new Text("Loading ..."),
      );
    }
    else if(state==0)
    {
      print("state login");
      return new Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      );
    }
    else if(state==1)
    {
      print("state home");
      return new Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: SearchSite(),
      );
    }

  }
}

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password=  TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    username.dispose();
    password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("Enter username"),
          TextFormField(
            controller: username,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),

          new Text("Enter password"),
          TextFormField(
            controller: password,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  Session login = new Session();
                  var data=json.decode("{\"userid\":\""+username.text+"\",\"password\":\""+password.text+"\"}");
                  login.post(login.getURL()+"LoginServlet",data).then((s){
                    if(json.decode(s)["status"])
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SearchSite()),
                      );
                    }
                    else{
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Login Failed')));
                    }
                  });
                  // If the form is valid, we want to show a Snackbar
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}