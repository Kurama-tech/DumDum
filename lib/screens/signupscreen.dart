import 'dart:io';

import 'package:dumdum/model/signup.dart';
import 'package:dumdum/providers/dropdownsprovider.dart';
import 'package:dumdum/providers/signupprovider.dart';
import 'package:dumdum/services/api.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/authprovider.dart';
import '../providers/loadingprovider.dart';
import '../providers/register_provider.dart';
import 'auth_checker.dart';
import 'loadingscreen.dart';

const List<String> busniessTypeList = <String>['Individual', 'Busniess'];

const List<String> busniessCategory = <String>[
  'Accounting and Financial Services',
  'Advertising and Marketing',
  'Agriculture and Farming',
  'Apparel and Accessories',
  'Automotive and Transportation',
  'Beauty and Personal Care',
  'Business Services',
  'Construction and Maintenance',
  'Consulting and Professional Services',
  'Consumer Goods and Services',
  'Education and Training',
  'Energy and Utilities',
  'Entertainment and Media',
  'Environmental Services',
  'Food and Beverage',
  'Health and Medical',
  'Home and Garden',
  'Hospitality and Tourism',
  'Information Technology',
  'Insurance and Risk Management',
  'Legal Services',
  'Manufacturing and Production',
  'Non-profit and Community Organizations',
  'Real Estate',
  'Retail and Wholesale',
  'Sports and Recreation',
  'Telecommunications and Networking',
  'Travel and Transportation',
  'Utilities and Waste Management'
];

class Signup extends StatefulHookConsumerWidget {
  const Signup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  File? avatar;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _proprietorController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    ref.read(avatarProvider.notifier).set(File(pickedFile!.path));
  }

  @override
  Widget build(BuildContext context) {

    var loading = ref.watch(loadingProvider).loading;
    var avatar = ref.watch(avatarProvider);

    if (loading) {
      return const LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvatarDisplay(),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('Pick a Profile pic')),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Name',
                          suffixText: '*'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name Cannot Be EmRpty';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Select a Type';
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: 'Select type',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        items: busniessTypeList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: ((value) {
                          ref.read(busniessTypeProvider.notifier).set(value!);
                        })),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Select a Category';
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: 'Select Category',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        items: busniessCategory
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: ((value) {
                          ref
                              .read(busniessCategoryProvider.notifier)
                              .set(value!);
                        })),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _companyController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Comapny',
                          suffixText: '*'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Company Cannot Be Empty';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _proprietorController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'proprietor',
                          suffixText: '*'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'proprietor Cannot Be Empty';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _locationController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Location',
                          suffixText: '*'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Location Cannot Be Empty';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () {
                            if(avatar == null){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select Avatar")));
                              }
                            if (_formKey.currentState!.validate() && avatar != null) {
                              var busniessType = ref.read(busniessTypeProvider);
                              var instance =
                                    ref.read(authRepositoryProvider).instance;
                              var uid = instance.currentUser?.uid;
                              var phone = instance.currentUser?.phoneNumber;
                              var busniessCat =
                                  ref.read(busniessCategoryProvider);
                              var data = SignupModel(
                                  _locationController.text,
                                  _companyController.text,
                                  busniessType,
                                  busniessCat,
                                  _proprietorController.text,
                                  _nameController.text,
                                  "active",
                                  phone!,
                                  uid!
                                  );
                              ref.read(signupProvider.notifier).set(data);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ImagesPicker()));
                            }
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class AvatarDisplay extends ConsumerWidget {
  const AvatarDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var avatar = ref.watch(avatarProvider);

    if (avatar == null) {
      return const CircleAvatar(
        backgroundImage:
            NetworkImage('https://www.w3schools.com/w3images/avatar2.png'),
        radius: 60.0,
      );
    }

    return CircleAvatar(
      backgroundImage: FileImage(avatar),
      radius: 60.0,
    );
  }
}

class ImagesPicker extends StatefulHookConsumerWidget {
  const ImagesPicker({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImagesPickerState();
}

class _ImagesPickerState extends ConsumerState<ImagesPicker> {


  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 80,
    );

    final files =
        pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    ref.read(imageFilesProvider.notifier).setImages(files);

    if (files.length < 3) {
      ref.read(enablesubmitProvider.notifier).set(false);
    } else {
      ref.read(enablesubmitProvider.notifier).set(true);
    }
  }

  Future<void> submit(BuildContext context) async {
    ref.read(loadingProvider.notifier).setloading();
    final reg = ref.watch(RegisterProvider.provider);

    var avatar = ref.read(avatarProvider);
    var data = ref.read(signupProvider);
    var images = ref.read(imageFilesProvider);

    try {
      var code = await createUser(avatar, data.data, images);
      if(code == 201){
        ref.read(loadingProvider.notifier).stoploading();
        ref.read(signedupProvider.notifier).set();
        Navigator.pop(context);

    }} catch (e) {
      print(e.toString());
      ref.read(loadingProvider.notifier).stoploading();
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
    }

    

  }

  @override
  Widget build(BuildContext context) {

    var loading = ref.watch(loadingProvider).loading;

    if (loading) {
      return const LoadingScreen();
    }

    var isSubmit = ref.watch(enablesubmitProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Images'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "*Select Atleast 3 Images*",
            style: TextStyle(fontSize: 18,  color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          const ImagesDisplay(),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: FilledButton(
                onPressed: isSubmit ? (){submit(context);} : null, child: const Text("Sumbit", style: TextStyle(fontSize: 15),)),
          )),
          const SizedBox(height: 10,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImages,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class ImagesDisplay extends ConsumerWidget {
  const ImagesDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var images = ref.watch(imageFilesProvider);

    if(images.isEmpty){
      return const Text("No Image Selected!", style: TextStyle(fontSize: 20),);
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 2,
      crossAxisCount: 3,
      children: images.map((imageFile) {
        return Image.file(
          imageFile,
          fit: BoxFit.cover,
        );
      }).toList(),
    );
  }
}
