import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'home.dart';
import 'notifications.dart';



class ParkStreet extends StatefulWidget {
  @override
  ParkStreetState createState() => new ParkStreetState();
}

class ParkStreetState extends State<ParkStreet> {
  final _formKey = GlobalKey<FormState>();
  final street_name = new TextEditingController();
  final parking_spot_no = new TextEditingController();
  final location_area = new TextEditingController();
  var cid;
  var session = new Session();



  @override
  Widget build(BuildContext context) {
    Session login = new Session();
    var p;
    login.get(login.getURL()+"VehiclesList").then((t){
      p=json.decode(t);
    });
    List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
    String _color = '';

    print(p);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Park on a street'),
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
          builder: (context) => new Form(
            key: _formKey,
            child: new Container(
                child: new Column(
                  children: <Widget>[
                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'Street name'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Empty streetnmae not allowed';
                        }
                      },
                      controller: street_name,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'Parking Spot no.'
                      ),
                      controller: parking_spot_no,
                    ),

                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: 'Location area'
                      ),
                      controller: location_area,
                    ),

                    new FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.color_lens),
                            labelText: 'Color',
                          ),
                          isEmpty: _color == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              value: _color,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  cid = newValue;
                                  _color = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _colors.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },

                    ),



                    new RaisedButton(
                      onPressed: (){
                        if (_formKey.currentState.validate()){
                          Map<String, String> postData = new Map<String, String>();
                          postData['street_name'] = street_name.text;
                          postData['parking_spot_no'] = parking_spot_no.text;
                          postData['location_area'] = location_area.text;
                          postData['cid'] = cid;
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
        )
    );
  }

  @override
  void dispose(){
    street_name.dispose();
    parking_spot_no.dispose();
    location_area.dispose();
    cid.dispose();
    super.dispose();
  }


}
