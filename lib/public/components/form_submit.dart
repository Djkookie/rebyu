import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class MyFormSubmit extends StatefulWidget {
  final Function()? formSubmit;
  final Color btnColor;
  final Color txtColor;
  final double btnRadius;
  final String buttonName;
  final double? width;
  final double? height;

  const MyFormSubmit({
    super.key,
    required this.formSubmit,
    required this.btnColor,
    required this.txtColor,
    required this.btnRadius,
    required this.buttonName,
    this.width,
    this.height
  });

  @override
  MyFormSubmitState createState() => MyFormSubmitState();
}

class MyFormSubmitState extends State<MyFormSubmit> {

  @override
  Widget build(BuildContext context) {
    return  FormHelper.submitButton(
      widget.buttonName,
      () => ((widget.formSubmit!)()),
      btnColor: widget.btnColor,
      borderColor: Colors.transparent,
      txtColor: widget.txtColor,
      borderRadius: widget.btnRadius,
      width: widget.width ?? 260,
      height: widget.height ??  57
    );
  }
}
