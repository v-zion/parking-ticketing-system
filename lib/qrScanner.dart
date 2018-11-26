
import 'dart:async';
import 'home.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'parkinfo.dart';
import 'session.dart';
import 'dart:convert';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('QR Code Scanner'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text('START CAMERA SCAN')
              ),
            )
            ,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(barcode, textAlign: TextAlign.center,),
            )
            ,
          ],
        ),
      ),
      drawer: drawit(context),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      print(barcode);
      Session session = new Session();
      var response = await session.get(Session.url + "AutoCompleteUser?latitude=" + Session.latitude.toString() +
          "&longitude=" + Session.longitude.toString() + "&term=" + barcode);
      Map<String, dynamic> jsonResponse = json.decode(response);
      print(jsonResponse);
      Map<String, dynamic> s = <String, dynamic>{};
      if (jsonResponse['status']){
        for (var d in jsonResponse['data']){
          if (d['label'] == barcode){
            s = d;
          }
        }
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => ParkInfoAll(s)));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}