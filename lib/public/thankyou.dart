import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/global/image_codec.dart';
// import 'package:rebyu/global/image_loader.dart';
// import 'package:rebyu/global/image_memory.dart';

class ThankYouPage extends GetView<AdminController> {
  const ThankYouPage({super.key});

  
  Widget getIconImageContent(Map iconMap, String image, String type, double size) {

    Widget itemWidget = CircleAvatar(
      backgroundColor: Colors.white,
      child:Icon(Icons.question_mark, size: size)
    );

    if(type == 'icon' && iconMap.isNotEmpty) {
      itemWidget =  CircleAvatar(
          backgroundColor: (iconMap['background'] != null) ? Color(int.parse(iconMap['background'])) : Colors.white,
          child: Icon(IconData(
            int.parse(iconMap['code_point']),
            fontFamily: iconMap['font_family'],
            fontPackage: iconMap['font_package']
          ), color: Color(int.parse(iconMap['color'])), size: size)
        );
      
    } else if(type == 'image' && image.isNotEmpty) {
      // itemWidget = ImageLoader(image: image);
      // itemWidget = ImageMemory(image: image);
      itemWidget = ImageCodec(image: image);
    }

    return itemWidget;
  }

  TextStyle getStringTextStyle(Map data, String type, String color, double size) {

    if(data[type] != null) {

      PickerFont pickerFont = PickerFont.fromFontSpec(data[type]);
      return GoogleFonts.getFont(
        color: Color((data[color] != null) ? int.parse(data[color]) : Colors.black.value),
        fontSize: int.parse(data[type == 'title_spec' ? 'title_size' : 'description_size'] ?? size.toString()).toDouble(),
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

    Map? compData = data['thankyou'];

    Map? iconMap = compData?['icon'];
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Color((compData != null && compData['background'] != null) ? int.parse(compData['background']) : Colors.white.value ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                constraints: const BoxConstraints(maxWidth: 580),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(
                      width: 180,
                      height: 180,
                      child: getIconImageContent(iconMap ?? {}, compData?['image'] ?? '', compData?['type'] ?? '', 60)
                    ),

                    const SizedBox(height: 20),

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

                    ElevatedButton(
                      onPressed: () => Get.toNamed('/'),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Color((compData?['button_background'] != null) ? int.parse(compData?['button_background']) : Colors.deepOrange.value)),
                        minimumSize: const WidgetStatePropertyAll(Size(250, 80)),
                      ),
                      child: Text('Go back', style: TextStyle(fontSize: 30, color: Color((compData?['button_color'] != null) ? int.parse(compData?['button_color']) : Colors.white.value))),
                    ),

                  ],
                )
              )
            )
          ]
        )
      )
    );
  }
}