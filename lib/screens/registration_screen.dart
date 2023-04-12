import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dumdum/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:dumdum/main.dart';
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
import 'package:sms_autofill/sms_autofill.dart';

import '../repository/auth_repository.dart';
import '../state/login_controller.dart';
import '../state/login_state.dart';

class Registation extends StatefulHookConsumerWidget {
  const Registation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegistationState();
}

class _RegistationState extends ConsumerState<Registation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  var vid = '';

  @override
  void initState() {
    super.initState();
  }
  List<String> type = ["Select Category","Business","Partnership","Individual"];


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

    if(loading){
      return const LoadingScreen();
    }


    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                      padding: const EdgeInsets.only(right: 20, left: 10),
                      height: 60,
                      child: Row(children: [
                        Row(
                          children:  [
                            const SizedBox(
                              width: 20,
                            ),

                            Container(
                              height: 40,
                              width: width * 0.5,
                              decoration: BoxDecoration(
                                border:
                                Border.all(width: 1, color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  buttonPadding: const EdgeInsets.only(
                                      left: 8, right: 8),
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
                                  items:
                                  type.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value:value,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
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
                        const SizedBox(
                          width: 5,

                        )
                      ])),
                  const SizedBox(height: 10,),
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
                                    //_settingModalBottomSheet();
                                  },
                                  child: reg.profileImage.isEmpty
                                      ? ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: 150,
                                        image: Image.asset('assets/My Picture.png').image,
                                      ))
                                      : ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.file(
                                      File(reg.profileImage),
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 120,
                                    ),
                                  )),
                            ],
                          ))
                    ],
                  ),

                  const Padding(padding:EdgeInsets.only(left: 0),
                    child: Text(
                      "Name",
                      style: TextStyle(
                          color: Color(0xff1f1d1d),
                          fontSize: 18,
                          fontFamily: "Lato"
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,
                  ),
                  Container(
                    width: width,
                    height: 70,
                    child: TextFormField(
                      controller: reg.nameController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xfffffde7),
                        border: InputBorder.none,
                        filled: true,
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


                  const Padding(padding:EdgeInsets.only(left: 0),
                    child: Text(
                      "Email",
                      style: TextStyle(
                          color: Color(0xff1f1d1d),
                          fontSize: 18,
                          fontFamily: "Lato"
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,
                  ),
                  Container(
                    width: width,
                    height: 70,
                    child: TextFormField(
                      controller: reg.emailController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xfffffde7),
                        border: InputBorder.none,
                        filled: true,
                      ),

                    ),
                  ),
                  Visibility(
                    visible: reg.emailError,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "*Email is Invalid.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),


                  const Padding(padding:EdgeInsets.only(left: 0),
                    child: Text(
                      "Phone No",
                      style: TextStyle(
                          color: Color(0xff1f1d1d),
                          fontSize: 18,
                          fontFamily: "Lato"
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,
                  ),
                  Container(
                    width: width,
                    height: 70,
                    child: TextFormField(
                      controller: reg.phoneController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xfffffde7),
                        border: InputBorder.none,
                        filled: true,
                      ),

                    ),
                  ),
                  Visibility(
                    visible: reg.phoneError,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "*quantity is Invalid.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),

                  const Padding(padding:EdgeInsets.only(left: 0),
                    child: Text(
                      "City",
                      style: TextStyle(
                          color: Color(0xff1f1d1d),
                          fontSize: 18,
                          fontFamily: "Lato"
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,
                  ),
                  Container(
                    width: width,
                    height: 70,
                    child: TextFormField(
                      controller: reg.cityController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xfffffde7),
                        border: InputBorder.none,
                        filled: true,
                      ),

                    ),
                  ),
                  Visibility(
                    visible: reg.cityError,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "*City is Invalid.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),


                  const Padding(padding:EdgeInsets.only(left: 0),
                    child: Text(
                      "State",
                      style: TextStyle(
                          color: Color(0xff1f1d1d),
                          fontSize: 18,
                          fontFamily: "Lato"
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,
                  ),
                  Container(
                    width: width,
                    height: 70,
                    child: TextFormField(
                      controller: reg.stateController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xfffffde7),
                        border: InputBorder.none,
                        filled: true,
                      ),

                    ),
                  ),
                  Visibility(
                    visible: reg.stateError,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "*State is Invalid.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Padding(padding:EdgeInsets.only(left: 0),
                    child: Text(
                      "Address",
                      style: TextStyle(
                          color: Color(0xff1f1d1d),
                          fontSize: 18,
                          fontFamily: "Lato"
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,
                  ),
                  Container(
                    width: width,
                    height: 70,
                    child: TextFormField(
                      controller: reg.addressController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xfffffde7),
                        border: InputBorder.none,
                        filled: true,
                      ),

                    ),
                  ),
                  Visibility(
                    visible: reg.addressError,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "*Address is Invalid.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),


                  const SizedBox(height: 20,),
                  Container(
                      width: width,
                      height: 50,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1f1d1d)),
                        onPressed: () {
                        //  reg.product(context);

                        },

                        child: Container(
                          width: 71.13,
                          child: const Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xfff6e80b),
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
      )
    );
  }
}
