import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebyu/admin/components/form_group.dart';
import 'package:rebyu/admin/components/picker_dialog.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/global/image_path.dart';

class FieldsGroup extends StatefulWidget {
  const FieldsGroup({
    super.key,
    required this.id,
    required this.list,
    required this.title,
    required this.subtitle,
    this.onChange
  });

  final List list;
  final String id;
  final String title;
  final String subtitle;
  final Function? onChange;

  @override
  State<FieldsGroup> createState() => _FieldsGroupState();
}

class _FieldsGroupState extends State<FieldsGroup> {

  final AdminController settings = Get.find();

  List<Widget> primaryType = [
    const Text('Icon'),
    const Text('Image'),
  ];

  PlatformFile? formFile;

  Image? featureImage;

  Timer? debounce;

  int defaulColor = 4288585374;

  Future iconPicker() async {
  
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: const SinglePickerConfiguration(
          iconPackModes: [
            IconPack.cupertino,
            IconPack.fontAwesomeIcons,
            IconPack.material,
            IconPack.allMaterial,
            IconPack.lineAwesomeIcons,
            IconPack.outlinedMaterial,
            IconPack.roundedMaterial,
            IconPack.sharpMaterial,
            IconPack.custom
          ],
      ),
    );


    if(icon != null) {

      Map? itemIcon = getItemData()['icon'];

      if(itemIcon != null) {
        itemIcon['code_point'] = icon.data.codePoint.toString();
        itemIcon['font_family'] = icon.data.fontFamily.toString();
        itemIcon['font_package'] = icon.data.fontPackage.toString();
      } else {

        itemIcon = {
          'code_point':icon.data.codePoint.toString(),
          'font_family':icon.data.fontFamily.toString(),
          'font_package':icon.data.fontPackage.toString()
        };
      }

      getItemData()['icon'] = itemIcon;
      settings.pagesData.refresh();
    }
  }

  IconData getIconData() {

    Map? itemIcon = getItemData()['icon'];

    int codePoint = Icons.image_search.codePoint;
    String? fontFamily = Icons.image_search.fontFamily;
    String? fontPackage;

    if(itemIcon != null) {
      if(itemIcon['code_point'] != null) {
        codePoint = int.parse(itemIcon['code_point']);
      }

      if(itemIcon['font_family'] != null) {
        fontFamily = itemIcon['font_family'];
      }

        if(itemIcon['font_package'] != null) {
        fontPackage = itemIcon['font_package'];
      }
    }

    return IconData(
        codePoint,
        fontFamily: fontFamily,
        fontPackage: fontPackage
    );
  }
  
  void iconChangeColor(Color color) {

    String colorString  = color.value.toString();
    
    Map? itemIcon = getItemData()['icon'];

    if(itemIcon != null) {
      itemIcon['color'] = colorString;
    } else {
      getItemData().putIfAbsent('color', () => colorString );
    }

      settings.pagesData.refresh();
  }

  void fontTitleChangeColor(Color color) {

    String colorString  = color.value.toString();

    String? itemIcon = getItemData()['font_title_color'];

    if(itemIcon != null) {
      getItemData()['font_title_color'] = colorString;
    } else {
      getItemData().putIfAbsent('font_title_color', () => colorString );
    }

    settings.pagesData.refresh();
  }

  void fontDescriptionChangeColor(Color color) {

    String colorString  = color.value.toString();

    String? itemIcon = getItemData()['font_description_color'];

    if(itemIcon != null) {
      getItemData()['font_description_color'] = colorString;
    } else {
      getItemData().putIfAbsent('font_description_color', () => colorString );
    }

    settings.pagesData.refresh();
  }

  Color getColorPoint(String parent, String type) {

    Map? itemData = (parent.isNotEmpty) ? getItemData()[parent] : getItemData();
    int? itemColor;

    if(itemData != null && itemData[type] != null) {
      itemColor = int.parse(itemData[type]);
    }

    return Color(itemColor ?? defaulColor);
  }
  
  void iconBackgroundChangeColor(Color color) {

    Map? itemIcon = getItemData()['icon'];

    if(itemIcon != null) {
      itemIcon['background'] = color.value.toString();
    }

    settings.pagesData.refresh();
  }

  void changeColor(Color color) {

    if(getItemData()['background'] != null) {
      getItemData()['background'] = color.value.toString();
    } else {
      getItemData().putIfAbsent('background', () => color.value.toString());
    }

    settings.pagesData.refresh();
  }

  void changeButtonColor(Color color) {

    if(getItemData()['button_color'] != null) {
      getItemData()['button_color'] = color.value.toString();
    } else {
      getItemData().putIfAbsent('button_color', () => color.value.toString());
    }

    settings.pagesData.refresh();
  }

  
  void changeButtonBackgroundColor(Color color) {

    if(getItemData()['button_background'] != null) {
      getItemData()['button_background'] = color.value.toString();
    } else {
      getItemData().putIfAbsent('button_background', () => color.value.toString());
    }

    settings.pagesData.refresh();
  }

  List<bool> getSelectedType() {

    List<bool> isSelectedPrime = [
      false,
      true
    ];

    bool isTrue = (getItemData()['type'] != null && getItemData()['type'] == 'icon');

    if(isTrue || getVisibleType() == 'icon') {
        isSelectedPrime[0] = true;
        isSelectedPrime[1] = false;
    }

    return isSelectedPrime;
  }

  String getVisibleType() {

    String selectedType = 'image';

    if(getItemData()['type'] != null) {
      selectedType = getItemData()['type'];
    }

    return selectedType;
  }

  String getSelectedFont(type) {

    String selectedFont = "Roboto";

    if(getItemData()[type] != null) {
      selectedFont = getItemData()[type];
    }

    return selectedFont;
  }

  TextStyle? getTextStyle(String type, double size) {

    Map? fontSpec = settings.pagesData[widget.id];

    if(fontSpec?[type] != null) {

      PickerFont pickerFont = PickerFont.fromFontSpec(fontSpec?[type]);

      return GoogleFonts.getFont(
        color: Color((fontSpec?['color'] != null) ? int.parse(fontSpec?['color']) : Colors.black.value),
        fontSize: size,
        pickerFont.fontFamily,
        fontWeight: pickerFont.fontWeight,
        fontStyle: pickerFont.fontStyle,
      );
    }

    return null;
  }

  void refreshData(key, value) {

    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(seconds: 2), () {
      if(getItemData()[key] != null ) {
        getItemData()[key] = value;
      } else {
        getItemData().putIfAbsent(key, () => value);
      }

      // ignore: avoid_print
      print(' TEST TEST $getItemData()');
    });
  }

  Future updatePreview() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      final file = result.files.first;
      // ignore: unused_local_variable
      Uint8List fileBytes = file.bytes as Uint8List;
      // ignore: unused_local_variable
      String fileName = file.name;

      String? theImage = settings.pagesData[widget.id]['image'];

      settings.imageUpload.add(file);

      setState(() {
        formFile = file;
      });

      if(theImage == null) {
        settings.pagesData[widget.id].putIfAbsent('image', () => fileName);
      } else {
        settings.pagesData[widget.id]['image'] = fileName;
      }

      setState(() {
        featureImage = Image.memory(fileBytes, fit: BoxFit.cover);
      });
    }
  }

  Map getItemData() {
    Map isMap = settings.pagesData.putIfAbsent(widget.id, () => {});
    return isMap;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyFormGroup(
                type: 'picker',
                name: "Background Color",
                iconColor: getColorPoint('', 'background'),
                onTap: () => colorPickerDialog(
                  context,
                  getColorPoint('', 'background'),
                  changeColor,
                  () {
                    Get.back();
                  }
                )
              ),
              const SizedBox(height: 20),

              (widget.id == 'home' || widget.id == 'thankyou') ? homeWidgets() : const SizedBox.shrink(),

              MyFormGroup(
                name: widget.title,
                customWidget: Row(
                  children: [
                    TextButton.icon(
                      style:  ButtonStyle(
                        // minimumSize: const WidgetStatePropertyAll(Size(100, 50)),
                        backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
                        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
                      ),
                      onPressed: () => fontFamilyDialog(context, settings.googleFonts, (PickerFont font) {
                        
                        getItemData()['title_font'] = font.fontFamily;
                        getItemData()['title_spec'] = font.toFontSpec();

                        settings.pagesData.refresh();
                      }),
                      label: Text(getSelectedFont('title_font'), style: getTextStyle('title_spec', 16)),
                      icon: const Icon(Icons.font_download, color: Colors.deepOrange),
                    ),
                    const SizedBox(width: 10),
                    MyFormGroup(
                      type: 'picker',
                      iconColor: getColorPoint('', 'font_title_color'),
                      defaultColumn: true,
                      pickerSize: 30,
                      pickerBorderWidth: 2,
                      onTap: () => colorPickerDialog(
                        context,
                        getColorPoint('', 'font_title_color'),
                        fontTitleChangeColor,
                        () {
                          
                          Get.back();
                        }
                      )
                    ),
                    const SizedBox(width: 5),
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      width: 40,
                      child: MyFormGroup(
                        containerHeight: 30,
                        contentPadding: 5,
                        fontSize: 13,
                        placeholder: 'Size',
                        defautlValue: getItemData()['title_size'] ?? '',
                        onChange: (value) {
                          refreshData('title_size', value);
                        },
                      ),
                    )
                  ],
                ),
                isMultiple: true,
                rows: 3,
                defautlValue: getItemData()['title'] ?? '',
                onChange: (value) {
                  refreshData('title', value);
                },
              ),

              const SizedBox(height: 20),

              MyFormGroup(
                name: 'Description',
                isMultiple: true,
                rows: 5,
                defautlValue: getItemData()['description'] ?? '',
                customWidget: Row(
                  children: [
                    TextButton.icon(
                      style:  ButtonStyle(
                        // minimumSize: const WidgetStatePropertyAll(Size(100, 50)),
                        backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
                        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
                      ),
                      onPressed: () => fontFamilyDialog(context, settings.googleFonts, (PickerFont font) {
                        
                        getItemData()['description_font'] = font.fontFamily;
                        getItemData()['description_spec'] = font.toFontSpec();

                        settings.pagesData.refresh();
                      }),
                      label: Text(getSelectedFont('description_font'), style: getTextStyle('description_font', 16)),
                      icon: const Icon(Icons.font_download, color: Colors.deepOrange),
                    ),
                    const SizedBox(width: 10),
                    MyFormGroup(
                      type: 'picker',
                      iconColor: getColorPoint('', 'font_description_color'),
                      defaultColumn: true,
                      pickerSize: 30,
                      pickerBorderWidth: 2,
                      onTap: () => colorPickerDialog(
                        context,
                        getColorPoint('', 'font_description_color'),
                        fontDescriptionChangeColor,
                        () {
                          
                          Get.back();
                        }
                      )
                    ),
                    const SizedBox(width: 5),
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      width: 40,
                      child: MyFormGroup(
                        containerHeight: 30,
                        contentPadding: 5,
                        fontSize: 13,
                        placeholder: 'Size',
                        defautlValue: getItemData()['description_size'] ?? '',
                        onChange: (value) {
                          refreshData('description_size', value);
                        },
                      ),
                    )
                  ]
                ),
                onChange: (value) {
                  refreshData('description', value);
                },
              ),
            ],
          ),
        ),
      ],
    ));
  }


  Widget homeWidgets() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToggleButtons(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.deepOrange,
          selectedColor: Colors.white,
          fillColor: Colors.deepOrange[200],
          isSelected:  getSelectedType(),
          constraints: const BoxConstraints(
            minHeight: 40.0,
            minWidth: 80.0,
          ),
          onPressed: (int index) {
            setState(() {
              String? selectedType;

              if(index == 0) {
                selectedType = 'icon';
              } else {
                selectedType = 'image';
              }

              getItemData()['type'] = selectedType;

              settings.pagesData.refresh();
            });
          },
          children: primaryType,
        ),
        
        const SizedBox(height: 20),

        Visibility(
          visible: getVisibleType() == 'icon',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const Text(
                'Choose Icon',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                ),
              ),

              const SizedBox(height: 5),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.all(Radius.circular(50.0))
                ),
                width: 100,
                height: 100,
                child: IconButton(
                  iconSize: 30.0,
                  autofocus: true,
                  disabledColor: Colors.black12,
                  focusColor: Colors.grey[100],
                  highlightColor: Colors.grey[100],
                  onPressed: iconPicker,
                  icon: Icon(getIconData()),
                  style: const ButtonStyle(
                    maximumSize: WidgetStatePropertyAll(Size(100, 100))
                  ),
                ),
              ),

              const SizedBox(height: 20),
              
              MyFormGroup(
                type: 'picker',
                name: "Icon Color",
                iconColor: getColorPoint('icon', 'color'),
                onTap: () => colorPickerDialog(
                  context,
                  getColorPoint('icon', 'color'),
                  iconChangeColor,
                  () {
                    
                    Get.back();
                  }
                )
              ),

              const SizedBox(height: 20),

              MyFormGroup(
                type: 'picker',
                name: "Icon Background",
                iconColor: getColorPoint('icon', 'background'),
                onTap: () => colorPickerDialog(
                  context,
                  getColorPoint('icon', 'background'),
                  iconBackgroundChangeColor,
                  () {
                    Get.back();
                  }
                )
              ),

              const SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
        
        Visibility(
          visible: getVisibleType() == 'image',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload Image',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                ),
              ),

              const SizedBox(height: 20),

              InkWell(
                child:  Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignOutside
                    )
                    
                  ),
                  width: 100,
                  height: 100,
                  child: (featureImage != null) ? featureImage
                  : (getItemData()['image'] != null) ? ImagePath(image: getItemData()['image'])
                  : const Icon(Icons.image_search_rounded, size: 30)
                ),
                onTap: () => updatePreview(),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => updatePreview(),
                child: const Text(
                  'Upload Image',
                  style: TextStyle(color: Colors.white)
                )
              ),
            ],
          )
        ),

        const SizedBox(height: 20),

        MyFormGroup(
            type: 'picker',
            name: "Button Color",
            iconColor: getColorPoint('', 'button_color'),
            onTap: () => colorPickerDialog(
              context,
              getColorPoint('', 'button_color'),
              changeButtonColor,
              () {
                Get.back();
              }
          )
        ),
        const SizedBox(height: 20),

        MyFormGroup(
            type: 'picker',
            name: "Button Background",
            iconColor: getColorPoint('', 'button_background'),
            onTap: () => colorPickerDialog(
              context,
              getColorPoint('', 'button_background'),
              changeButtonBackgroundColor,
              () {
                Get.back();
              }
          )
        ),
        
        const SizedBox(height: 20),
      ],
    );
  }
}