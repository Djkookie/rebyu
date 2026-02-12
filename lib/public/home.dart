import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/global/image_codec.dart';
// import 'package:rebyu/global/image_loader.dart';
// import 'package:rebyu/global/image_memory.dart';

class HomePublic extends GetView<AdminController> {
  const HomePublic({super.key});

  @override
  Widget build(BuildContext context) {

    // return streamLoader(controller.pagesData.stream, getScaffoldWidget);

    return Obx(() => getScaffoldWidget(context, controller.pagesData));
  }

  Widget getIconImageContent(Map iconMap, String image, String type, double size) {

    Widget itemWidget = Icon(Icons.question_mark, size: size);

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
  
  TextStyle? getStringTextStyle(Map data, String type, String color, dynamic size) {

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

    return null;
  }


  Widget getScaffoldWidget(context, data) {

    Map? item = data['home'];

    Map? iconMap = item?['icon'];
    
    return Scaffold(
      backgroundColor: Color((item != null && item['background'] != null) ? int.parse(item['background']) : Colors.white.value ),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 580),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: getIconImageContent(iconMap ?? {}, item?['image'] ?? '', item?['type'] ?? '', 60)
              ),

              const SizedBox(height: 20),

              Text(
                item?['title'] ?? 'Lorem ipsum dolor sit amit',
                textAlign: TextAlign.center,
                style: getStringTextStyle(item ?? {}, 'title_spec', 'font_title_color' , 35),
              ),

              const SizedBox(height: 20),

              Text(
                item?['description'] ?? 'Lorem ipsum dolor sit amit',
                textAlign: TextAlign.center,
                style: getStringTextStyle(item ?? {}, 'description_spec', 'font_description_color' , item?['description_size'] ?? 20),
              ),

              const SizedBox( height: 40 ),
              Flex(
                direction: (MediaQuery.sizeOf(context).width < 768) ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/redirects'),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color((item?['button_background'] != null) ? int.parse(item?['button_background']) : Colors.deepOrange.value)),
                      minimumSize: const WidgetStatePropertyAll(Size(250, 80)),
                    ),
                    child: Text('Yes', style: TextStyle(fontSize: 30, color: Color((item?['button_color'] != null) ? int.parse(item?['button_color']) : Colors.white.value))),
                  ),
                  const SizedBox(width: 20, height: 20),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/complaint'),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color((item?['button_background'] != null) ? int.parse(item?['button_background']) : Colors.deepOrange.value)),
                      minimumSize: const WidgetStatePropertyAll(Size(250, 80)),
                    ),
                    child: Text('No', style: TextStyle(fontSize: 30, color: Color((item?['button_color'] != null) ? int.parse(item?['button_color']) : Colors.white.value))),
                  )
                ],
              )
              

            ],
          ),
        ),
      )
    );
  }
}