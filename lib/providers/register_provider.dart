import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/home_repository.dart';


class RegisterProvider with ChangeNotifier {
  // final HomeRepository _homeRepo = HomeRepository();
  // HomeRepository get homeRepo => _homeRepo;
  final HomeRepository _homeRepo = HomeRepository();
  HomeRepository get homeRepo => _homeRepo;


  String profileImage = '';
  String category = "Select Category";


  bool nameError = false;
  bool emailError = false;
  bool cityError = false;
  bool addressError = false;
  bool phoneError = false;
  bool stateError = false;
  String uid = '' ;



  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _phoneController = TextEditingController();
  TextEditingController get phoneController => _phoneController;

  final TextEditingController _stateController = TextEditingController();
  TextEditingController get stateController => _stateController;


  final TextEditingController _cityController = TextEditingController();
  TextEditingController get cityController => _cityController;

  final TextEditingController _addressController = TextEditingController();
  TextEditingController get addressController => _addressController;



  uploadProfileImage(String filepath) async {
    profileImage = filepath;
    notifyListeners();
  }


  Future<dynamic> UpdateUid(String filepath)  {
    uid = filepath;

    notifyListeners();
    return  _homeRepo.fetchAndSetCategory(uid);

  }

  updateCategory(String type) async {
    category = type;
    notifyListeners();
  }




  static final provider = ChangeNotifierProvider((ref) => RegisterProvider());

}
