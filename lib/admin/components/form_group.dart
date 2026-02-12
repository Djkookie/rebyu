import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class MyFormGroup extends StatelessWidget {
  final Function? onsave;
  final Function? onChange;
  final Function? onTap;
  final String? hintText;
  final String? name;
  final String? type;
  final String? value;
  final String? hint;
  final String? defautlValue;
  final String? placeholder;
  final bool? isNumeric;
  final bool? isMultiple;
  final Color? borderColor;
  final int? rows;
  final Icon? icon;
  final Widget? customWidget;
  final double? contentPadding;
  final Icon? prefixIcon;
  final List<dynamic>? listData;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? pickerBorderWidth;
  final double? fontSize;
  final double? containerWidth;
  final double? containerHeight;
  final bool? defaultColumn;
  final double? pickerSize;
  const MyFormGroup({
    super.key,
    this.onsave,
    this.onChange,
    this.onTap,
    this.hintText,
    this.name,
    this.type,
    this.value,
    this.hint,
    this.defautlValue,
    this.placeholder,
    this.isNumeric,
    this.isMultiple,
    this.borderColor,
    this.rows,
    this.icon,
    this.customWidget,
    this.contentPadding,
    this.prefixIcon,
    this.listData,
    this.backgroundColor,
    this.iconColor,
    this.pickerBorderWidth,
    this.fontSize,
    this.containerWidth,
    this.containerHeight,
    this.defaultColumn,
    this.pickerSize,
  });

  @override
  Widget build(BuildContext context) {

    List<Widget> items = [
      (name != null) ?
      Row(
        children: [
          icon ?? const SizedBox.shrink(),
          Text(
            name ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(width: 10),
          customWidget ?? const SizedBox.shrink()
        ],
      ) : const SizedBox.shrink(),
      (defaultColumn == null) ? const SizedBox(height: 5) : const SizedBox(width: 5),
      Container(
        width: containerWidth,
        height: containerHeight,
        color: backgroundColor ?? Colors.transparent,
        child: getFieldByType(context, type ?? 'text'),
      )
    ];

    return (defaultColumn == null) ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
    ) : Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: items
    );
  }

  getFieldByType(context, type) {

    Widget? theWidget;

    switch (type) {
      case 'text':
        theWidget = FormHelper.inputFieldWidget(
          context,
          name ?? 'default-text',
          placeholder ?? '',
          (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return 'Required';
            } else if(name == 'Password' && onValidateVal.length < 6) {
              return 'length must exceed to 6 characters';
            }
          },
          (onSave) => onsave!(onSave),
          onChange: onChange,
          fontSize: fontSize ?? 14,
          borderFocusColor: Theme.of(context).primaryColor,
          hintColor: Colors.black12,
          contentPadding: contentPadding ?? 10,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          initialValue: defautlValue ?? '',
          borderColor: borderColor ?? Colors.grey,
          borderRadius: 5,
          paddingTop: 0,
          paddingBottom: 0,
          paddingLeft: 0,
          paddingRight: 0,
          maxLength: 200,
          isNumeric: isNumeric ?? false,
          isMultiline: isMultiple ?? false,
          multilineRows: rows ?? 10,
          prefixIcon: prefixIcon,
        );
        break;
      case 'dropdown':
        theWidget = FormHelper.dropDownWidget(
          context,
          hint ?? 'N/A',
          value ?? '',
          listData ?? [],
          (value) => onChange!(value),
          (value){
            // ignore: avoid_print
            print('VALUE $value');
          },
          borderFocusColor: Theme.of(context).primaryColor,
          hintColor: Colors.black12,
          contentPadding: 10,
          textColor: Colors.black,
          borderColor: borderColor ?? Colors.grey,
          borderRadius: 5,
          paddingTop: 0,
          paddingBottom: 0,
          paddingLeft: 0,
          paddingRight: 0,
          prefixIcon: prefixIcon,
        );
        break;
      case 'picker':
        theWidget = InkWell(
          onTap: () => onTap!(),
          child: Container(
            decoration: BoxDecoration(
              color: iconColor ?? Colors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(color: Colors.grey.shade200, width: pickerBorderWidth ?? 1)
            ),
            width: pickerSize ?? 40,
            height: pickerSize ?? 40,
          ),
        );
        break;
      default:
    }


    return theWidget;
  }
}
