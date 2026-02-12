import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class MyFormField extends StatelessWidget {
  final Function? onsave;
  final Function? onChange;
  final String name;
  final double inputRadius;
  final bool obscureText;
  final bool isNumeric;

  const MyFormField({
    super.key,
    this.onsave,
    this.onChange,
    required this.name,
    required this.inputRadius,
    required this.obscureText,
    required this.isNumeric,
  });

  @override
  Widget build(BuildContext context) {
    return FormHelper.inputFieldWidget(
      context,
      name.toLowerCase(),
      name,
      (onValidateVal) {
        if (onValidateVal.isEmpty) {
          return 'Required';
        } else if(name == 'Password' && onValidateVal.length < 6) {
          return 'length must exceed to 6 characters';
        }
      },
      (onSave) => onsave!(onSave),
      obscureText: obscureText,
      onChange: onChange,
      hintFontSize: 16,
      borderFocusColor: Theme.of(context).primaryColor,
      showPrefixIcon: true,
      prefixIcon: const Icon(Icons.password),
      prefixIconColor: Colors.white,
      hintColor: Colors.white,
      borderRadius: inputRadius,
      contentPadding: 19,
      paddingLeft: 25,
      paddingRight: 25,
      textColor: Colors.white,
      borderColor: Colors.white,
      backgroundColor: Colors.transparent,
      isNumeric: isNumeric
    );
  }
}
