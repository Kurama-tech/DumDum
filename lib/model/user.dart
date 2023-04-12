
import 'package:flutter/material.dart';
import 'dart:convert';

class User with  ChangeNotifier  {
  final String name;
  final String company;
  final String proprietor;
  final String contact;
  final String uid;
  final String status;
  final String location;
  final String busniess_category;
  final String busniess_type;
  final List<String> images;
  final String avatar;



  User({
    required this.name,
    required this.company,
    required this.proprietor,
    required this.contact,
    required this.uid,
    required this.status,
    required this.location,
    required this.busniess_category,
    required this.busniess_type,
    required this.images,
    required this.avatar,

  });

}
