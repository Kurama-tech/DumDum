import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;


Dio dio = Dio();
String url = 'http://64.227.144.134:8002/api/';

class HomeRepository {


   getUserbyID(String uid) async {
    Dio dio = Dio();
    final URL = url+"users/${uid}";
    try {
      final response = await dio.get(URL);

      print(response);

      return response.data;
    } catch (error) {
      throw (error);
    }
  }


   fetchAndSetCategory(String uid) async {
     print(uid);
     final url1 = Uri.parse(url+"users/${uid}");
     try {
       final response = await http.get(url1);

       print(response.body);
       if(response.body==null)
         return "null";

     } catch (error) {
       throw (error);
     }
   }






}
