/*
 * Based on an answer by Richard Heap on stackoverflow.
 * Original link:
 * https://stackoverflow.com/questions/50299253/flutter-http-maintain-php-session
 */


import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Session {
  static final String url="http://192.168.31.90:8080/pvc_servlets/";
  static double latitude = null;
  static double longitude = null;
  var uid="";
  Widget bell=new Icon(Icons.notifications_none);
  bool notify;
  static final Session _session = new Session._internal();
  factory Session(){
    return _session;
  }
  Session._internal();

  Map<String, String> headers = {};
  String getURL(){
    return url;
  }

  Future<String> get(String url) async {
//    print(url);
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future<String> post(String url, dynamic data) async {
//    print(data);
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return response.body;
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
