// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Loading extends ChangeNotifier {
  bool loading = false;


  void setloading() {
    loading = true;
    notifyListeners();
  }
  void stoploading() {
    loading = false;
    notifyListeners();
  }

}

final loadingProvider = ChangeNotifierProvider<Loading>(
  (ref) => Loading(),
);