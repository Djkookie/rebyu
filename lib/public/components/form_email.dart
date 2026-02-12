import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class MyFormEmail extends StatelessWidget {
  final Function? onsave;
  final Function? onChange;
  final double inputRadius;

  const MyFormEmail({
    super.key,
    required this.inputRadius,
    this.onsave,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return FormHelper.inputFieldWidget(
      context,
      "email",
      "Email Address",
      (onValidateVal) {
        if (onValidateVal.isEmpty) {
            return 'Required';
        }
        else if(!onValidateVal.toString().trim().isValidEmail()) {
          return 'Invalid Email Address';
        }
      },
      (onSave) => onsave!(onSave),
      onChange: onChange,
      hintFontSize: 16,
      borderFocusColor: Theme.of(context).primaryColor,
      showPrefixIcon: true,
      prefixIconColor: Colors.white,
      prefixIcon: const Icon(Icons.email, color: Colors.white),
      hintColor: Colors.white,
      borderRadius: inputRadius,
      contentPadding: 19,
      paddingLeft: 25,
      paddingRight: 25,
      textColor: Colors.white,
      borderColor: Colors.white,
      backgroundColor: Colors.transparent,
    );
  }
}
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}