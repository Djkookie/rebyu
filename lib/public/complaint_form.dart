import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebyu/admin/components/form_group.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/public/components/form_submit.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/ProgressHUD.dart';

class ComplaintForm extends GetView<AdminController> {
  const ComplaintForm({super.key});


  Future<bool> sendEmail(String output) async {
    final url = Uri.parse("https://hair-feathers.co.uk/wp-json/custom/v1/send-email");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "to": 'junefajardo94@gmail.com',
        "subject": 'Complain Form Hair-feather',
        "message": output
      }),
    );


    if (response.statusCode == 200) {
      print("Email sent successfully!");
      return true;
    } else {
      print("Failed to send email: ${response.body}");
      return false;
    }
  }

  TextStyle getStringTextStyle(Map data, String type, String color, dynamic size) {

    if(data[type] != null) {

      PickerFont pickerFont = PickerFont.fromFontSpec(data[type]);
      return GoogleFonts.getFont(
        color: Color((data[color] != null) ? int.parse(data[color]) : Colors.black.value),
        fontSize: int.parse(data['title_size'] ?? size.toString()).toDouble(),
        pickerFont.fontFamily,
        fontWeight: pickerFont.fontWeight,
        fontStyle: pickerFont.fontStyle,
      );
    }

    return TextStyle(
      color: Colors.black,
      fontSize: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => theForm(controller.pagesData));
  }


  Widget theForm(data) {

    Map? compData = data['form'];

    RxBool processState = false.obs;

    String? name;
    String? email;
    String? message;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Color((compData != null && compData['background'] != null) ? int.parse(compData['background']) : Colors.white.value ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: TextButton.icon(
          onPressed: () {
            Get.offAndToNamed('/');
          },
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
            size: 22,
          ),
          label: const Text('Back', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
        leadingWidth: 100,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 57),
          child: ListView(
            shrinkWrap: true,
            children: [

              Obx( () => Center(
                child: (processState.isTrue) ? const CircularProgressIndicator(color: Colors.black) : Container(
                  constraints: const BoxConstraints(maxWidth: 580),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        compData?['title'] ?? 'Lorem ipsum dolor sit amit',
                        textAlign: TextAlign.center,
                        style: getStringTextStyle(compData ?? {}, 'title_spec', 'font_title_color' , 35),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        compData?['description'] ?? 'Lorem ipsum dolor sit amit',
                        textAlign: TextAlign.center,
                        style: getStringTextStyle(compData ?? {}, 'description_spec', 'font_description_color' , 20),
                      ),

                      const SizedBox(height: 30),

                       MyFormGroup(
                        name: 'Name',
                        onChange: (value) {
                          name = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      MyFormGroup(
                        name: 'Email',
                        onChange: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      MyFormGroup(
                        name: 'Message',
                        isMultiple: true,
                        rows: 10,
                        onChange: (value) {
                          message = value;
                        },
                      ),

                      const SizedBox(height: 20),

                      MyFormSubmit(
                        buttonName: "Submit",
                        txtColor: Colors.white,
                        btnRadius: 30,
                        btnColor:  Colors.deepOrange.shade700,
                        formSubmit: () async {

                          List errors = [];

                          if(name.isNull) {
                            errors.add('Name is required!');
                          }

                          if(email.isNull) {
                            errors.add('Email is required!');
                          } else {
                            if(!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(email!)) {
                              errors.add('Email is not valid!');
                            }
                          }

                          if(errors.isNotEmpty) {

                            Get.snackbar(
                                'Error',
                                errors.join('\n'),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white,
                                colorText: Colors.redAccent
                            );
                          } else {

                            processState.value = true;

                            String output = "Name: $name<br>Email: $email<br>Message: $message";

                            if (await sendEmail(output)) {
                              Get.toNamed('/thankyou');
                            } else {

                              processState.value = false;


                              Get.snackbar(
                                  'Error',
                                  'Something went wrong',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white
                              );
                            }
                          }
                          //
                        },
                      ),
                    ],
                  ),
                )
              ))
            ],
          )
        )
      )
    );
  }
}