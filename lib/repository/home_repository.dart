import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();
String url = 'http://64.227.144.134:8002/api/';

class HomeRepository {
  getUserbyID(String uid) async {
    Dio dio = Dio();
    final URL = url + "users/${uid}";
    try {
      final response = await dio.get(URL);

      print(response.data);

      try {
        if (response.data == null)
          // print(response.body);

          return null;

        else
          //print(response.body);

          return response.data;


      } catch (error) {
        throw (error);
      }


      return response.data;
    } catch (error) {
      throw (error);
    }
  }


  Future<String> createUser(
    String name,
    String company,
    List<String> images,
    String proprietor,
    String contact,
    String userid1,
    String status,
    String location,
    String busniess_category,
    String busniess_type,
  ) async {
    final url = Uri.parse('http://64.227.144.134:8002/api/user');
    print(images[0]);
    final User? user1 = FirebaseAuth.instance.currentUser;
    final userid = user1!.uid;
    print(userid);



    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "avatar":"https://images.pexels.com/photos/16168011/pexels-photo-16168011.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          'name': name,
          'company': company,
          'images': images,
          'proprietor': proprietor,
          'contact': contact,
          'userid': userid,
          'status': status,
          'location': location,
          'busniess_category': busniess_category,
          'busniess_type': busniess_type,
        }),
      );

      return response.body;
    } catch (error) {
      throw (error);
    }
  }

  Future<String> uploadImage(
    String profileImage,
  ) async {
    final url = Uri.parse('http://64.227.144.134:8002/api/upload');
    print(url);
    try {
      var request = http.MultipartRequest('POST', url);
      if (profileImage.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('files', profileImage));
      }

      var res = await request.send();
      final respStr = await res.stream.bytesToString();

      return respStr;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
