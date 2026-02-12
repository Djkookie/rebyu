import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import 'components/form_email.dart';
import 'components/form_field.dart';
import 'components/form_submit.dart';

class AppLogin extends StatefulWidget {
  const AppLogin({super.key});

  @override
  State<AppLogin> createState() => _AppLoginState();
}

class _AppLoginState extends State<AppLogin> {

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final AdminController settings = Get.find();

  bool isApiCallProcess = false;

  String? username, password;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          color: Colors.white,
          opacity: .1,
          key: UniqueKey(),
          child: Form(
            key: globalKey,
            child: loginUIContainer(),
          ),
        ),
    );
  }
  

  loginUIContainer() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/rebyu-bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.2
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops:  [0.1, 1.5],
                    colors:  [
                      Color.fromRGBO(117, 121, 255, 1),
                      Color.fromRGBO(178, 36, 239, 1),
                    ],
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.settings, size: 50, color: Colors.blueGrey,),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    'Log In'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white
                    ),
                    
                  ),

                  const SizedBox(height: 30),

                  MyFormEmail(
                    inputRadius: 10.0,
                    onsave: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  MyFormField(
                    name: 'Password',
                    obscureText: true,
                    inputRadius: 10,
                    onsave: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    isNumeric: false
                  ),

                  const SizedBox(height: 30),

                  MyFormSubmit(
                    buttonName: "Login",
                    txtColor: Colors.blue.shade900,
                    btnRadius: 30.0,
                    btnColor: Colors.white,
                    width: 150,
                    formSubmit: () {

                      if(validateAndSave()) {
                        setState(() {
                          isApiCallProcess = true;
                        });

                        settings.signInWithEmailAndPassword(
                          username,
                          password
                        ).then((value) => {
                          
                          if(value['status'] != null) {
                            FormHelper.showSimpleAlertDialog(
                              context,
                                value['status'],
                                value['message'],
                                "Ok",
                                () {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  Navigator.pop(context);
                                },
                              )
                            } else {
                              Get.offAllNamed('/sites')
                            }
                          });
                      }
                    }
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    
    }

    return false;
  }
}
