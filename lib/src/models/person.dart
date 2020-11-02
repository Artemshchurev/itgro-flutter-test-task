import 'package:flutter/material.dart';

class Person {
  String name;
  String picture;
  String bigPicture;
  String address;
  String email;

  Person({
    @required this.name,
    @required this.picture,
    @required this.bigPicture,
    @required this.address,
    @required this.email,
  });
}