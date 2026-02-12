import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:get/get.dart';

colorPickerDialog(context, pickerColor, changeColor, callback) {

  List<Color> colors = [
  Colors.black,
  Colors.white,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.indigo,
  Colors.blue,
  Colors.yellow,
  Colors.grey,

  ];

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder:(BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Pick Color',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              fontSize: 18.0
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
        ),
        contentPadding: const  EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15
        ),
        content: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              const SizedBox(height: 10),
              ColorPicker(
                pickerHsvColor: HSVColor.fromColor(Colors.grey),
                pickerAreaHeightPercent: .5,
                colorPickerWidth: 400,
                labelTypes: const [],
                enableAlpha: true,
                portraitOnly: true,
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                displayThumbColor: true,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                constraints: const BoxConstraints(maxHeight: 160),
                color: Colors.grey.shade200,
                child: BlockPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                  availableColors: colors,
                  
                )
              )
            ],
          )
        ),
        actionsPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        actionsAlignment: MainAxisAlignment.end,
        buttonPadding: const EdgeInsets.symmetric(vertical: 20),
        actions: [
          ElevatedButton(
            onPressed: callback,
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Colors.white
              )
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 10.0),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Submit', style: TextStyle(color: Colors.white))
          )
        ]
      );

    }
  );
}

fontFamilyDialog(context, googleFonts, fontChange) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[200],
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            height: 500,
            child: FontPicker(
              showInDialog: true,
              initialFontFamily: 'Anton',
              showFontVariants: false,
              showFontInfo: false,
              onFontChanged: fontChange,
              googleFonts: googleFonts,
            ),
          ),
        ),
      );
    },
  );
}

removeItemDialog(context, title, onCallback) {

  return  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData().copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.yellow[700]),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(
                      color: Colors.deepPurple.shade700
                    )
                  ),
                ),
                minimumSize: const WidgetStatePropertyAll(Size(150, 50))
              ),
            ),
          ),
          child:  AlertDialog(
            title: const Text(
              'Are you sure want to remove?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
            ),
            contentPadding: const  EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15
            ),
            actionsPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            actionsAlignment: MainAxisAlignment.center,
            buttonPadding: const EdgeInsets.symmetric(vertical: 20),
            content: Container(
              constraints: const BoxConstraints(maxHeight: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                      color: Colors.deepPurple
                    ),
                  ),
                ]
              ) ,
            ) ,
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.white
                  ),
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: onCallback,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.red[600]
                  ),
                ),
                child: const Text(
                  'Remove',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              )
            ]
          )
        );
      }
    );
}