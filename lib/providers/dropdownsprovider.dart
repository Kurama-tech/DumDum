
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class BusniessCategoryNotifier extends StateNotifier<String> {

  BusniessCategoryNotifier() : super("");

  void set(String value) async {
    state = value;
  }
}

class BusniessTypeNotifier extends StateNotifier<String> {

  BusniessTypeNotifier() : super("");

  void set(String value) async {
    state = value;
  }
}

class AvatarNotifier extends StateNotifier<File?> {

  AvatarNotifier() : super(null);

  void set(File? value) async {
    state = value;
  }
}

class EnabledSubmitNotifier extends StateNotifier<bool> {

  EnabledSubmitNotifier() : super(false);

  void set(bool value) async {
    state = value;
  }
}



class ImageFilesNotifier extends StateNotifier<List<File>> {
  ImageFilesNotifier() : super([]);

  void setImages(List<File> files) {
    state = files;
  }

  void addImage(File files) {
    state.add(files);
  }
}

final busniessTypeProvider = StateNotifierProvider<BusniessTypeNotifier, String>(
  (ref) => BusniessTypeNotifier(),
);


final busniessCategoryProvider = StateNotifierProvider<BusniessCategoryNotifier, String>(
  (ref) => BusniessCategoryNotifier(),
);


final avatarProvider = StateNotifierProvider<AvatarNotifier, File?>(
  (ref) => AvatarNotifier(),
);

final enablesubmitProvider = StateNotifierProvider<EnabledSubmitNotifier, bool>(
  (ref) => EnabledSubmitNotifier(),
);

final imageFilesProvider = StateNotifierProvider<ImageFilesNotifier, List<File>>((ref) => ImageFilesNotifier());