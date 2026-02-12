import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class AdminSubmitBtn extends StatelessWidget {
  final Function()? formSubmit;
  final String buttonName;
  final Icon icon;

  const AdminSubmitBtn({
    super.key,
    required this.formSubmit,
    required this.buttonName,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return  FormHelper.submitButton(
      buttonName,
      () => ((formSubmit!)()),
      borderColor: Colors.transparent,
      borderRadius: 20,
      btnColor: Colors.white,
      txtColor: Colors.deepPurple,
      prefixIcon: icon,
      height: 35,
      width: 190,
      fontSize: 14
    );
  }
}
