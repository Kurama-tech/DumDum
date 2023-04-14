import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dumdum/providers/register_provider.dart';
import 'package:dumdum/screens/home.dart';
import 'package:dumdum/screens/multiimage.dart';
import 'package:flutter/material.dart';
import 'package:dumdum/providers/authprovider.dart';
import 'package:dumdum/providers/loadingprovider.dart';
import 'package:dumdum/providers/optinputprovider.dart';
import 'package:dumdum/providers/vidprovider.dart';
import 'package:dumdum/screens/loadingscreen.dart';
import 'package:dumdum/screens/otpscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../repository/auth_repository.dart';
import '../state/login_controller.dart';
import '../state/login_state.dart';
import 'package:http/http.dart' as http;


class Registation extends StatefulHookConsumerWidget {
  const Registation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegistationState();
}

class _RegistationState extends ConsumerState<Registation> {
  final ImagePicker _picker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  var vid = '';

  @override
  void initState() {
    super.initState();
  }

  List<String> type = [
    "Select Category",
    "Business",
    "Partnership",
    "Individual"
  ];



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));
    var loading = ref.watch(loadingProvider).loading;
    final reg = ref.watch(RegisterProvider.provider);

    ref.listen<LoginState>(loginControllerProvider, ((previous, state) {
      if (state is LoginStateError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.error),
        ));
      }
    }));

    if (loading) {
      return const LoadingScreen();
    }

    void _settingModalBottomSheet() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SizedBox(
              height: 150,
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Camera'),
                      onTap: () async {
                        Navigator.pop(context);
                        final pickedFile = await _picker.pickImage(source: ImageSource.camera, maxHeight: 500, maxWidth: 500, imageQuality: 50);

                        reg.uploadProfileImage(pickedFile!.path);
                      }),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    onTap: () async {
                      Navigator.pop(context);
                      final pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500, imageQuality: 50);

                      reg.uploadProfileImage(pickedFile!.path);
                    },
                  ),
                ],
              ),
            );
          });
    }

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(

            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top:0,bottom: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [

                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 150,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              //   _settingModalBottomSheet();
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(25),
                                              child: Image.network("https://images.pexels.com/photos/16168011/pexels-photo-16168011.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                                                fit: BoxFit.cover,
                                                height: 120,
                                                width: 120,
                                              ),
                                            )),
                                      ],
                                    ))
                              ],
                            ),
                            SizedBox(height: 20,),


                            Container(
                              width: width,
                              height: 70,
                              child:  TextFormField(
                                autofocus: true,
                                controller: reg.nameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  labelText: 'Name',
                                ),
                              ),
                            ),
                            Visibility(
                              visible: reg.nameError,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "*name is Invalid.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: width,
                              height: 70,
                              child: TextFormField(
                                autofocus: true,
                                controller: reg.companyNameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  labelText: 'Company Name',
                                ),
                              ),
                            ),
                            Visibility(
                              visible: reg.companyNameControllerError,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "*Name is Invalid.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                height: 60,
                                child: Row(children: [
                                  Row(
                                    children: [

                                      Container(
                                        height: 60,
                                        width: width*0.85,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: Colors.grey),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            buttonPadding:
                                            const EdgeInsets.only(left: 8, right: 8),
                                            alignment: AlignmentDirectional.centerStart,
                                            //   borderRadius: BorderRadius.circular(12),
                                            //   color: ConstantColors.mainColor,
                                            // ),
                                            buttonHeight: 20,
                                            buttonWidth: 60,
                                            itemHeight: 35,
                                            dropdownMaxHeight: height * 0.60,
                                            value: reg.category,
                                            icon: const Icon(Icons.arrow_drop_down,
                                                color: Colors.black),
                                            onChanged: (newValue) {
                                              reg.updateCategory(newValue!);
                                            },
                                            items: type.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Row(
                                                  children: [

                                                    Text(value,
                                                        style: const TextStyle(
                                                          fontFamily: "Lato",
                                                          color: Colors.black,
                                                          fontSize: 17,
                                                        ))
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ])),
                            SizedBox(height: 10,),

                            Container(
                              width: width,
                              height: 70,
                              child:TextFormField(
                                autofocus: true,
                                controller: reg.busniess_categoryController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  labelText: 'Business Category',
                                ),
                              ),
                            ),
                            Visibility(
                              visible: reg.busniess_categoryControllerError,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "*Category is Invalid.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: width,
                              height: 70,
                              child: TextFormField(
                                autofocus: true,
                                controller: reg.phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  labelText: 'Phone Number',
                                ),
                              ),
                            ),
                            Visibility(
                              visible: reg.phoneControllerError,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "*Number is Invalid.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: width,
                              height: 70,
                              child: TextFormField(
                                autofocus: true,
                                controller: reg.locationController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  labelText: 'Location',
                                ),
                              ),
                            ),
                            Visibility(
                              visible: reg.locationControllerError,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "*location is Invalid.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Container(
                              width: width,
                              height: 70,
                              child:  TextFormField(
                                autofocus: true,
                                controller: reg.proprietorController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  labelText: 'Proprietor',
                                ),
                              ),
                            ),
                            Visibility(
                              visible: reg.proprietorControllerError,
                              child: Column(
                                children: const [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "*Proprietor is Invalid.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),

                      Container(
                          width: width,
                          height: 50,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: FilledButton(

                            onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>MyImagePicker()));
                              //  reg.product(context);
                            },
                            child: Container(
                              width: 71.13,
                              child: const Text(
                                "Submit",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )),
                    ]),
              ),
            ),
          ),
        ),

    );
  }
}
class MyImagePicker extends StatefulHookConsumerWidget {
  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends ConsumerState<MyImagePicker> {

  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];


  @override
  Widget build(BuildContext context) {
    final reg = ref.watch(RegisterProvider.provider);
    void selectImages() async {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        imageFileList!.addAll(selectedImages);
      }
      setState(() {
      });
    }
    Future<void> _uploadImages() async {
      final url = Uri.parse('http://64.227.144.134:8002/api/upload');
      final request = http.MultipartRequest('POST', url);

      for (var i = 0; i < imageFileList!.length; i++) {
        final image = await http.MultipartFile.fromPath(
            'files', imageFileList![i].path);
        request.files.add(image);
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      reg.uploadMultipleImage(responseData,context);

      // Do something with the response data
      print(responseData);
    }


    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Pick Images from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    selectImages();
                  }
              ),
              SizedBox(height: 20,),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        itemCount: imageFileList!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Image.file(File(imageFileList![index].path), fit: BoxFit.cover);
                        }
                    ),
                  )
              ),


              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Upload",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    _uploadImages();
                    AlertDialog(
                      title: const Text('DumDum!'),
                      content: Text(""),
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


                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>MyHomePage(title:"")));


                    // reg.AddUser(context);
                  }
              ),
            ],
          ),
        )
    );
  }
}

