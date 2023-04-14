
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dumdum/model/signup.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();
String url = 'http://64.227.144.134:8002/api/';


 Future<dynamic> _uploadImages(List<File> images) async {

      try{
          final url = Uri.parse('http://64.227.144.134:8002/api/upload');
          final request = http.MultipartRequest('POST', url);

          for (var i = 0; i < images.length; i++) {
            final image = await http.MultipartFile.fromPath(
                'files', images[i].path);
            request.files.add(image);
          }

          final response = await request.send();
          final responseData = await response.stream.bytesToString();
          // Do something with the response data
          print(responseData);
          return responseData;
      } 
      catch (e) {
        rethrow;
      }
      
    }


Future<dynamic> createUser(File? avatar, SignupModel data, List<File> images) async {
  final formDataAvatar = FormData.fromMap({
    'files': await MultipartFile.fromFile(avatar!.path),
  });

  try {
    final avatarUploadresponse = await Dio().post(
      'http://64.227.144.134:8002/api/upload',
      data: formDataAvatar,
    );
    var avatarurl = json.decode(avatarUploadresponse.data).cast<String>().toList();
    final imagesUploadResponse = await _uploadImages(images);
    var imagesUrlList = json.decode(imagesUploadResponse).cast<String>().toList();

    final uploadData = jsonEncode({
          "avatar": avatarurl[0],
          'name': data.name,
          'company': data.company,
          'images': imagesUrlList,
          'proprietor': data.proprietor,
          'contact': data.phone,
          'userid': data.userid,
          'status': data.status,
          'location': data.location,
          'busniess_category': data.busniess_category,
          'busniess_type': data.busniess_type,
        });
    
    final response = await Dio().post(
      'http://64.227.144.134:8002/api/user',
      data: uploadData,
      options: Options(
        contentType: 'application/json',
      ),
    );
    return response.statusCode;
    
  } catch (e) {
    rethrow;
  }
}
