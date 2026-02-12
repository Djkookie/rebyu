import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/global/image_codec.dart';
//import 'package:rebyu/global/image_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialList extends GetView<AdminController> {
  const SocialList({super.key});


  Future<void> launchInBrowserView(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String getPageTitle() {
    String title = 'Page Title';

    if(controller.pageSettings['title'] != null) {
      title = controller.pageSettings['title'];
    }

    return title;
  }

  Widget getTitleWidget() {

    Map? fontSpec = controller.pageSettings;

    if(fontSpec['font_spec'] != null) {

      PickerFont pickerFont = PickerFont.fromFontSpec(fontSpec['font_spec']);

      return Text(getPageTitle(), textAlign: TextAlign.center, style: GoogleFonts.getFont(
        color: Color((fontSpec['color'] != null) ? int.parse(fontSpec['color']) : Colors.black.value),
        fontSize: int.parse(fontSpec['font_size'] ?? 40.toString()).toDouble(),
        pickerFont.fontFamily,
        fontWeight: pickerFont.fontWeight,
        fontStyle: pickerFont.fontStyle,
      ));
    }

    return const SizedBox.shrink();
  }

  Color getPageBackground() {

    var bg = controller.pageSettings;

    if(bg['background'] != null) {
      bg['background'] = int.parse(bg['background'].toString());
    }

    return Color(bg['background'] ?? 4290502395);
  }

  
  double getPageRating() {

    double rating = 0.0;

    if(controller.pageSettings['rating'] != null) {
      rating = int.parse(controller.pageSettings['rating']).toDouble();
    }

    return rating;
  }
  
  Widget getIconImageContent(iconMap, image, type) {

    Widget itemWidget =  const Icon(Icons.question_mark, size: 18.0);

    if(iconMap != null && type == 'icon') {

      itemWidget = CircleAvatar(
          backgroundColor: (iconMap?['background'] != null) ? Color(int.parse(iconMap?['background'])) : Colors.grey[400],
          child: Icon(IconData(
          int.parse(iconMap['code_point']),
          fontFamily: iconMap['font_family'],
          fontPackage: iconMap['font_package']
        ), color: Color(int.parse(iconMap['color']))),
      );

    } else if(image != null) {
      itemWidget = SizedBox(
        width: 100,
        // child: ImageLoader(image: image),
        child: ImageCodec(image: image),
      );
    }

    return itemWidget;
  }


  @override
  Widget build(BuildContext context) {
    
    return Obx( () =>Scaffold(
      backgroundColor: getPageBackground(),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
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
        child: ListView(
          shrinkWrap: true,
          children: [

            getTitleWidget(),
            const SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    getPageRating().toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20.0)
                ),
                const SizedBox(width: 10),
                StarRating(
                  size: 40.0,
                  rating: getPageRating(),
                  color: Colors.deepOrange,
                  borderColor: Colors.grey,
                  allowHalfRating: true,
                  starCount: 5,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: controller.socialDataFront.length * 70,
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemCount: controller.socialDataFront.length,
                  itemBuilder: (context, index) {

                    Map dataMap = controller.socialDataFront[index];
                    Map? iconMap = dataMap['icon'];
                    Map? trailingIconMap = dataMap['trailing'];
                    String? image = dataMap['image'];
                    String? type = dataMap['type'];

                    return ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      textColor: (dataMap['color'] != null) ? Color(int.parse(dataMap['color'])) : Colors.black,
                      selectedColor: (dataMap['color'] != null) ? Color(int.parse(dataMap['color'])) : Colors.black,
                      tileColor: (dataMap['background'] != null) ? Color(int.parse(dataMap['background'])) : Colors.white,
                      selectedTileColor: (dataMap['background'] != null) ? Color(int.parse(dataMap['background'])) : Colors.white,
                      leading: getIconImageContent(iconMap, image, type ),
                      title: Text(dataMap['title'] ?? 'N/A'),
                      subtitle: Text(dataMap['link'] ?? 'N/A'),
                      trailing: (trailingIconMap != null) ?
                        Icon(IconData(
                          int.parse(trailingIconMap['code_point']),
                          fontFamily: trailingIconMap['font_family'],
                          fontPackage: trailingIconMap['font_package']
                        ),
                        color: (trailingIconMap['color'] != null) ? Color(int.parse(trailingIconMap['color'])) : Colors.black
                        ) : const Icon(Icons.arrow_circle_right, size: 18.0),
                      onTap: () => launchInBrowserView(Uri.parse(Uri.encodeFull(dataMap['link'])))
                    );
                  },
                )
              )
            )
          ],
          
        )
      )
    )
    );

  }
}