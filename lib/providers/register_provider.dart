import 'dart:convert';
import 'dart:io';

import 'package:dumdum/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/home_repository.dart';

import 'package:http/http.dart' as http;

class RegisterProvider with ChangeNotifier {
  final User? user1 = FirebaseAuth.instance.currentUser;


  // final HomeRepository _homeRepo = HomeRepository();
  // HomeRepository get homeRepo => _homeRepo;
  final HomeRepository _homeRepo = HomeRepository();
  HomeRepository get homeRepo => _homeRepo;



      String profileImage = '';
  String category = "Select Category";



  bool nameError = false;
  bool companyNameControllerError = false;
  bool phoneControllerError = false;
  bool locationControllerError = false;
  bool proprietorControllerError = false;
  bool busniess_categoryControllerError = false;
  String userid = '' ;
  List<String> images = [];
  List<String> responseImage = [];
  List<String> responseFile = [];




  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _companyNameController = TextEditingController();
  TextEditingController get companyNameController => _companyNameController;


  final TextEditingController _phoneController = TextEditingController();
  TextEditingController get phoneController => _phoneController;





  final TextEditingController _locationController = TextEditingController();
  TextEditingController get locationController => _locationController;


  final TextEditingController _proprietorController = TextEditingController();
  TextEditingController get proprietorController => _proprietorController;

  final TextEditingController _busniess_categoryController = TextEditingController();
  TextEditingController get busniess_categoryController => _busniess_categoryController;

  //
  //


  uploadProfileImage(String filepath) async {
    profileImage = filepath;
    notifyListeners();
  }
  String photos = "";


  uploadMultipleImage(String filepath,BuildContext context) async {
    photos = filepath;
    print(photos);
    AddUser(context);
    notifyListeners();
  }








  updateCategory(String type,) async {
    category = type;
    notifyListeners();
  }
  //
  // Image(BuildContext context) async {
  //
  //   notifyListeners();
  //   if (profileImage == "")
  //     nameError = true;
  //   else {
  //     await _homeRepo
  //         .uploadImage(profileImage).then((response) async {
  //       final responseData = json.decode(response);
  //       print(responseData);
  //       _showDialog("User Registration Succesful", context);
  //     });
  //   }
  //   notifyListeners();
  // }
  //






  AddUser(BuildContext context) async {
    List<String> photoList = photos.split(",");
    print(photoList);

    //     nameError = false;
 //     companyNameControllerError = false;
 //     phoneControllerError = false;
 //     locationControllerError = false;
 //     proprietorControllerError = false;
 //     busniess_categoryControllerError = false;
 //    notifyListeners();
 // if(user1!=null){
 //      userid = user1!.uid;
 //    }
 //
 //    else {
      await _homeRepo
          .createUser(nameController.text, companyNameController.text, photoList, proprietorController.text, phoneController.text, userid, "active", locationController.text, busniess_categoryController.text, category)
          .then((response) async {
        final responseData = json.decode(response);
        print(responseData);
        _showDialog("User Registration Succesful", context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "title")));
      });
    //}
    notifyListeners();
  }


  void _showDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('DumDum!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size.fromHeight(40.0)),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            child: const Text('Okay'),
            onPressed: () {
              profileImage = "";


              notifyListeners();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }




  static final provider = ChangeNotifierProvider((ref) => RegisterProvider());

}
