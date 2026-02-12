import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebyu/admin/add_item.dart';
import 'package:rebyu/admin/components/form_group.dart';
import 'package:rebyu/admin/components/picker_dialog.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/global/image_codec.dart';
// import 'package:rebyu/global/image_loader.dart';


class SocialItemsLinks extends StatefulWidget {
  const SocialItemsLinks({
    super.key,
    required this.items,
    required this.selected,
    required this.selectedCard
  });

  final dynamic items;
  final int? selected;
  final Function selectedCard;

  @override
  State<SocialItemsLinks> createState() => SocialItemsLinksState();
}


class SocialItemsLinksState extends State<SocialItemsLinks> {

  final AdminController settings = Get.find();
  
  Timer? debounce;

  int? defaulColor = 4288585374;

  var pageTitle = ''.obs;

  final Map fontWeight = {
    'bold': FontWeight.bold,
    'normal': FontWeight.normal,
    100: FontWeight.w100,
    200: FontWeight.w200,
    300: FontWeight.w300,
    400: FontWeight.w400,
    500: FontWeight.w500,
    600: FontWeight.w600,
    700: FontWeight.w700,
    800: FontWeight.w800,
    900: FontWeight.w900,
  };

  final Map fontStyle = {
    'normal': FontStyle.normal,
    'italic': FontStyle.italic,
  };

  Widget getIconImageContent(iconMap, image, type) {

    Widget itemWidget =  CircleAvatar(
      backgroundColor:  Colors.grey[400],
      child: const Icon(Icons.question_mark, size: 18.0)
    );

    if((iconMap != null || image != null) && type != null) {

      if(type == 'icon') {

        itemWidget = CircleAvatar(
            backgroundColor: (iconMap?['background'] != null) ? Color(int.parse(iconMap?['background'])) : Colors.grey[400],
            child: Icon(IconData(
            int.parse(iconMap['code_point']),
            fontFamily: iconMap['font_family'],
            fontPackage: iconMap['font_package']
          ), color: Color((iconMap['color'] != null) ? int.parse(iconMap['color']) : Colors.white.value)),
        );
        
      } else if(image != null) {
        itemWidget = SizedBox(
          width: 100,
          //child: ImageLoader(image: image),
          child: ImageCodec(image: image),
        );
      }
    }

    return itemWidget;
  }

  String? getPageTitle() {
    String? title = settings.pageSettings['title'];
  
    return title;
  }

  dynamic getPageTitleSize() {
    dynamic size = settings.pageSettings['font_size'];

    return size;
  }

  String getSelectedFont() {

    String selectedFont = "Roboto";

    if(settings.pageSettings['font_family'] != null) {
      selectedFont = settings.pageSettings['font_family'];
    }

    return selectedFont;
  }

  Widget getTitleWidget() {

    Map? fontSpec = settings.pageSettings;

    if(fontSpec['font_spec'] != null) {

      PickerFont pickerFont = PickerFont.fromFontSpec(fontSpec['font_spec']);

      return Text(getPageTitle() ?? 'N/A', style: GoogleFonts.getFont(
        color: Color((fontSpec['color'] != null) ? int.parse(fontSpec['color']) : Colors.black.value),
        fontSize: int.parse(fontSpec['font_size'] ?? 40.toString()).toDouble(),
        pickerFont.fontFamily,
        fontWeight: pickerFont.fontWeight,
        fontStyle: pickerFont.fontStyle,
      ));
    }

    return const SizedBox.shrink();
  }

  Map getSelectedFontStyle() {

    Map? fontStyle = settings.pageSettings['font_stye'];

    Map mapStyle = {
      'family' : 'Aclonica_regular',
      'family_fallback' : 'Aclonica',
      'weight': 400,
      'style': 'normal',
      'inherit': true
    };

    if(fontStyle != null) {
      mapStyle = fontStyle;
    }

    return mapStyle;
  }

  double getPageRating() {

    double rating = 0.0;

    if(settings.pageSettings['rating'] != null) {
      rating = int.parse(settings.pageSettings['rating']).toDouble();
    }

    return rating;
  }

  Color getTrailingIconColorPoint() {

    Map? itemIcon = widget.items['trailing'];
    int? iconColor;

    if(itemIcon != null && itemIcon['color'] != null) {
      iconColor = int.parse(itemIcon['color']);
    }

    return Color(iconColor ?? 4288585374);
  }

  Color getPageBackground() {

    Map bg = settings.pageSettings;
    int? pageBg;

    if(bg['background'] != null) {
      pageBg = int.parse(bg['background']);
    }

    return Color(pageBg ?? 4290502395);
  }

  Color getPageFontColor() {

    Map bg = settings.pageSettings;

    int? pageBg;

    if(bg['color'] != null) {
      pageBg = int.parse(bg['color']);
    }

    return Color(pageBg ?? 4278190080);
  }

  void pageBackgroundColor (Color color) {

    Map? itemIcon = settings.pageSettings;

    itemIcon['background'] = color.value.toString();

    settings.pageSettings.refresh();
  }

  void pageFontColor (Color color) {

    Map? itemIcon = settings.pageSettings;

    itemIcon['color'] = color.value.toString();

    settings.pageSettings.refresh();
    settings.socialData.refresh();
  }

  void refreshData() {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(seconds: 2), () {
      settings.pageSettings.refresh();
    });
  }


  @override
  void initState() {

    // setState(() {
      pageTitle.value = settings.pageSettings['title'] ?? 'N/A';
    // });
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

    MediaQueryData queryData = MediaQuery.of(context);

    Widget topSettings = Container(
      padding: const EdgeInsets.all(10.0),
      width: (queryData.size.width > 760) ? 200 : double.maxFinite,
      decoration:  BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: const BorderRadius.all(Radius.circular(10.0))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyFormGroup(
            type: 'picker',
            name: "Background",
            defaultColumn: true,
            iconColor: getPageBackground(),
            pickerBorderWidth: 4,
            onTap: () => colorPickerDialog(
              context,
              getPageBackground(),
              pageBackgroundColor,
              () {
                setState(() {
                    settings.pageSettings['background'] = Colors.grey.value.toString();
                });
                Get.back();
              }
            )
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                SizedBox(
                  width: 103,
                  child: MyFormGroup(
                    placeholder: 'Company Name',
                    defautlValue: getPageTitle(),
                    onChange: (value) {

                      settings.pageSettings['title'] = value;
                      refreshData();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 60,
                  child: MyFormGroup(
                    fontSize: 13,
                    placeholder: 'Size',
                    defautlValue: getPageTitleSize(),
                    onChange: (value) {
                      settings.pageSettings['font_size'] = value;
                      refreshData();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            style:  ButtonStyle(
              minimumSize: const WidgetStatePropertyAll(Size(double.maxFinite, 50)),
              backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
            ),
            onPressed: () => fontFamilyDialog(context, settings.googleFonts, (PickerFont font) {

              TextStyle textSyle = font.toTextStyle();


              settings.pageSettings['font_family'] = font.fontFamily;
              settings.pageSettings['font_spec'] = font.toFontSpec();
              settings.pageSettings['font_style'] = {
                'family': textSyle.fontFamily,
                'family_fallback': textSyle.fontFamilyFallback!.join(','),
                'weight': textSyle.fontWeight!.value,
                'style': textSyle.fontStyle!.name,
                'inherit': textSyle.inherit,
              };

              settings.socialData.refresh();
            }),
            label: Text(getSelectedFont(), style: TextStyle(fontFamily: getSelectedFont())),
            icon: const Icon(Icons.font_download, color: Colors.deepOrange),
          ),

          const SizedBox(height: 10),
          MyFormGroup(
            type: 'picker',
            name: "Text Color",
            defaultColumn: true,
            iconColor: getPageFontColor(),
            pickerBorderWidth: 4,
            onTap: () => colorPickerDialog(
              context,
              getPageFontColor(),
              pageFontColor,
              () {
                setState(() {
                    settings.pageSettings['color'] = Colors.grey.value.toString();
                });
                Get.back();
              }
            )
          ),

          const SizedBox(height: 40),
          TextButton.icon(
            style:  const ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(double.maxFinite, 50)),
              backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
            ),
            onPressed: () {

              settings.updateSocialData(widget.items).whenComplete(() {
                Get.snackbar(
                  'Social Data',
                  'Successfully Updated',
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.check, color: Colors.green),
                  ),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  maxWidth: 500,
                  shouldIconPulse: true,
                  padding: const EdgeInsets.all(20),
                  borderRadius: 10.0,
                  forwardAnimationCurve: Curves.bounceInOut
                );
              });

              settings.updatePageSettings();

              if(settings.imageUpload.isNotEmpty) {

                final formFile = settings.imageUpload.first;
                final fileName = settings.imageUpload.first.name;
                Uint8List fileBytes = formFile?.bytes as Uint8List;
                settings.uploadFileData('images', fileName, fileBytes);
              }

            },
            label: const Text('Update', style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.save, color: Colors.white),
          ),
        ],
      )
    );

    List<Widget> childrenWidgets = [
      (queryData.size.width > 760) ?
      Positioned(
        top: 10,
        right: 10,
        child: topSettings
      ) : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: topSettings,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getTitleWidget(),
            const SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getPageRating().toString(), style: const TextStyle(fontSize: 20.0)),
                const SizedBox(width: 10),
                StarRating(
                  size: 40.0,
                  rating: getPageRating(),
                  color: Colors.deepOrange,
                  borderColor: Colors.grey,
                  allowHalfRating: true,
                  starCount: 5,
                  onRatingChanged: (rating) => setState(() {
                    settings.pageSettings['rating'] = rating.toString();
                  }),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {

                    Map? iconMap = widget.items[index]['icon'];
                    String? image = widget.items[index]['image'];
                    String? type = widget.items[index]['type'];
                    Map? trailingIconMap = widget.items[index]['trailing'];

                    return Directionality(
                      textDirection: (iconMap != null && iconMap['direction'] == 'right') ? TextDirection.rtl : TextDirection.ltr,
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        selected: widget.selected == index,
                        textColor: (widget.items[index]['color'] != null) ? Color(int.parse(widget.items[index]['color'])) : Colors.black,
                        selectedColor: (widget.items[index]['color'] != null) ? Color(int.parse(widget.items[index]['color'])) : Colors.black,
                        tileColor: (widget.items[index]['background'] != null) ? Color(int.parse(widget.items[index]['background'])) : Colors.white,
                        selectedTileColor: (widget.items[index]['background'] != null) ? Color(int.parse(widget.items[index]['background'])) : Colors.white,
                        leading: getIconImageContent(iconMap, image, type ?? 'icon' ),
                        title: Text(widget.items[index]['title'] ?? 'N/A'),
                        subtitle: Text(widget.items[index]['link'] ?? 'N/A'),
                        
                        trailing: (trailingIconMap != null) ?
                          Icon(IconData(
                            int.parse(trailingIconMap['code_point']),
                            fontFamily: trailingIconMap['font_family'],
                            fontPackage: trailingIconMap['font_package']
                          ),
                          color: (trailingIconMap['color'] != null) ? Color(int.parse(trailingIconMap['color'])) : Colors.black
                          ) : const Icon(Icons.arrow_circle_right, size: 18.0),
                        onTap: () {
                          widget.selectedCard(index);
                        },
                      )
                    );
                  },
                )
              )
            )
          ]
        )
      )
    ];

    return Obx(() => Scaffold(
      backgroundColor: getPageBackground(),
      floatingActionButton: AddNewItem(items: widget.items),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Theme(
        data: ThemeData().copyWith(
          listTileTheme: const ListTileThemeData(
            tileColor: Colors.white,
            selectedColor: Colors.white,
            selectedTileColor: Colors.deepOrange
          )
        ),
        child: (queryData.size.width > 760) ? Stack(
          children: childrenWidgets
        ) : ListView(
          children: childrenWidgets
        )
      )
    ));
  }
}

class ItemsNone {

  String? id,
    title,
    description,
    image,
    link,
    background,
    codePoint,
    fontFamily,
    fontPackage,
    color,
    iconBackground,
    direction;

  ItemsNone({
    this.id,
    this.title,
    this.description,
    this.image,
    this.link,
    this.background,
    this.codePoint,
    this.fontFamily,
    this.fontPackage,
    this.color,
    this.iconBackground,
    this.direction,
  });

}