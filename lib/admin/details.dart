// ignore_for_file: avoid_print

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/components/form_group.dart';
import 'package:rebyu/admin/components/picker_dialog.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/global/image_loader.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({super.key,required this.item});
  final Map item;

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> with TickerProviderStateMixin {

  late TabController tabControl;

  final AdminController settings = Get.find();

  PlatformFile? formFile;
  
  Image? featureImage;

  Timer? debounce;

  int defaulColor = 4288585374;

  List<Widget> primaryType = [
    const Text('Icon'),
    const Text('Image'),
  ];

  List<bool> getSelectedType() {

    List<bool> isSelectedPrime = [
      true,
      false
    ];

    bool isTrue = (widget.item['type'] != null && widget.item['type'] == 'image');

    if(isTrue || getVisibleType() == 'image') {
        isSelectedPrime[1] = true;
        isSelectedPrime[0] = false;
    }

    return isSelectedPrime;
  }

  String getVisibleType() {

    String selectedType = 'icon';

    if(widget.item['type'] != null) {
      selectedType = widget.item['type'];
    }

    return selectedType;
  }

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

      Map? itemIcon = widget.item['icon'];

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

      widget.item['icon'] = itemIcon;
      settings.socialData.refresh();
    }
  }

  Future trailingIconPicker() async {
  
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

   debugPrint('Picked Icon:  $icon');


    if(icon?.data != null) {

      Map? itemIcon = widget.item['trailing'];

      if(itemIcon != null) {
        itemIcon['code_point'] = icon?.data.codePoint.toString();
        itemIcon['font_family'] = icon?.data.fontFamily.toString();
        itemIcon['font_package'] = icon?.data.fontPackage.toString();
      } else {

        itemIcon = {
          'code_point':icon?.data.codePoint.toString(),
          'font_family':icon?.data.fontFamily.toString(),
          'font_package':icon?.data.fontPackage.toString()
        };

      }

      widget.item['trailing'] = itemIcon;
      settings.socialData.refresh();
    }
  }

  void iconChangeColor(Color color) {

    String stringColor = color.value.toString();

    Map? itemIcon = widget.item['icon'];

    if(itemIcon != null) {
      itemIcon['color'] = stringColor;
    }

    settings.socialData.refresh();
  }

  void trailingIconChangeColor(Color color) {

    String stringColor = color.value.toString();

    Map? itemIcon = widget.item['trailing'];

    if(itemIcon != null) {
      itemIcon['color'] = stringColor;
    }

    settings.socialData.refresh();
  }

  void backgroundChangeColor(Color color) {

    widget.item['background'] = color.value.toString();

    settings.socialData.refresh();
  }

  void textChangeColor(Color color) {
 
    widget.item['color'] = color.value.toString();

    settings.socialData.refresh();
  }

  void iconBackgroundChangeColor(Color color) {
    
    String stringColor = color.value.toString();

    Map? itemIcon = widget.item['icon'];

    if(itemIcon != null) {
      itemIcon['background'] = stringColor;
    } else {
      itemIcon?.putIfAbsent('background', () => stringColor);
    }

    settings.socialData.refresh();
  }

  Color getBackgroundColorPoint() {

    var bg = widget.item['background'];

    if(bg != null && bg != '') {
      bg = int.parse(bg);
    }

    return Color(bg ?? defaulColor);
  }

  Color getColorPoint(String parent, String type) {

    int? colorPoint;

    if(parent.isNotEmpty) {
      Map? itemIcon = widget.item[parent];

      if(itemIcon != null && itemIcon[type] != null) {
        colorPoint = int.parse(itemIcon[type]);
      }
    } else {
      String? itemIcon = widget.item[type];

      if(itemIcon != null) {
        colorPoint = int.parse(itemIcon);
      }
    }

    return Color(colorPoint ?? defaulColor);
  }

  getIconDirection() {
    Map? itemIcon = widget.item['icon'];
    String defaultLeft = 'left';
    if(itemIcon != null && itemIcon['direction'] != null) {
      defaultLeft = itemIcon['direction'];
    }

    return defaultLeft;
  }

  IconData getIconData(type) {

    Map? itemIcon = widget.item[type];

    int codePoint = (type == 'icon') ? Icons.image_search.codePoint : Icons.arrow_circle_right.codePoint;
    String? fontFamily = (type == 'icon') ? Icons.image_search.fontFamily : Icons.arrow_circle_right.fontFamily;
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

  void refreshData() {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(seconds: 2), () {
      settings.socialData.refresh();
    });
  }

  @override
  void initState() {
    tabControl = TabController(length: 2, vsync: this, animationDuration: Duration.zero);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 1,
        title: Text(
          widget.item['title'],
          style: const TextStyle(
            fontWeight: FontWeight.w500
          ),
        ),
        actions: [
          
          TextButton.icon(
            onPressed: () {

              if(settings.countItems.value > 1) {
                removeItemDialog(context,  widget.item['title'], () {
                  settings.removeItemData(widget.item['id']).whenComplete(() {
                    Get.back();
                    Get.snackbar(
                      widget.item['title'],
                      'Succsessfully Updated',
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
                    );
                    
                  });
                });
              }
            },
            label: Text('Delete', style: TextStyle(color: (settings.countItems.value > 1) ? Colors.deepPurple : Colors.grey)),
            icon:  Icon(Icons.delete_forever, color: (settings.countItems.value > 1) ? Colors.deepOrange : Colors.grey),
          ),
        ],
        bottom: TabBar(
          controller: tabControl,
          overlayColor: const WidgetStatePropertyAll(Colors.white),
          dividerColor: Colors.transparent,
          labelColor: Colors.deepOrange,
          tabAlignment: TabAlignment.fill,
          
          tabs: const [
            Tab(
              icon: Icon(Icons.list),
              child: Text(
                'Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.settings),
              child: Text(
                'Advance',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabControl,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [

                MyFormGroup(
                  type: 'picker',
                  name: "Background Color",
                  iconColor: getBackgroundColorPoint(),
                  onTap: () => colorPickerDialog(
                    context,
                    getBackgroundColorPoint(),
                    backgroundChangeColor,
                    () {

                      Get.back();
                    }
                  )
                ),

                const SizedBox(
                  height: 20,
                ),
                MyFormGroup(
                  type: 'picker',
                  name: "Text Color",
                  iconColor: getColorPoint('','color'),
                  onTap: () => colorPickerDialog(
                    context,
                    getColorPoint('','color'),
                    textChangeColor,
                    () {
                      Get.back();
                    }
                  )
                ),

                const SizedBox(
                  height: 20,
                ),
                
                // MyFormGroup(
                //   borderColor: Colors.grey,
                //   name: 'Style / Design',
                //   type: 'dropdown',
                  
                //   onChange: (value) {
                
                //   },
                //   value: 'style 1',
                //   listData: const [
                //     {
                //       'id': 'style 1',
                //       'name': 'Style 1',
                //     },
                //     {
                //       'id': 'style 2',
                //       'name': 'Style 2',
                //     },
                //     {
                //       'id': 'style 3',
                //       'name': 'Style 3',
                //     },
                //     {
                //       'id': 'style 4',
                //       'name': 'Style 4',
                //     },
                //     {
                //       'id': 'style 5',
                //       'name': 'Style 5',
                //     },
                //   ],
                // ),
                
                // const SizedBox(
                //   height: 20,
                // ),

                MyFormGroup(
                  name: 'Title',
                  borderColor: Colors.grey,
                  defautlValue: widget.item['title'],
                  onChange: (value) {

                    widget.item['title'] = value;
                    refreshData();
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                MyFormGroup(
                  name: 'Redirect Link',
                  borderColor: Colors.grey,
                  isMultiple: true,
                  defautlValue: widget.item['link'],
                  rows: 5,
                  onChange: (value) {

                    widget.item['link'] = value;
                    refreshData();
                  },
                ),
              ]
            )
          ),

          ListView(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
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

                          widget.item['type'] = selectedType;

                          settings.socialData.refresh();
                        });
                      },
                      children: primaryType,
                    ),

                    const Divider(indent: 2, height: 50),


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
                              icon: Icon(getIconData('icon')),
                              style: const ButtonStyle(
                                maximumSize: WidgetStatePropertyAll(Size(100, 100))
                              ),
                            ),
                          ),
        
                          const SizedBox(height: 20),
                          
                          MyFormGroup(
                            type: 'picker',
                            name: "Icon Color",
                            iconColor: getColorPoint('icon','color'),
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

                          MyFormGroup(
                            borderColor: Colors.grey,
                            name: 'Icon Direction',
                            type: 'dropdown',
                            
                            onChange: (value) {
                              Map? iconMap =  widget.item['icon'];
                              
                              if(iconMap != null) {
                                iconMap['direction'] = value;
                              }
                              settings.socialData.refresh();
                            },
                            value: getIconDirection(),
                            listData: const [
                              {
                                'id': 'right',
                                'name': 'Right',
                              },
                              {
                                'id': 'left',
                                'name': 'Left',
                              },
                            ],
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
                              : (widget.item['image'] != null) ? ImageLoader(image: widget.item['image'])
                              : const Icon(Icons.image_search_rounded, size: 30)
                            ),
                            onTap: () => updatePreview('images', false, false),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () => updatePreview('images', false, false),
                            child: const Text(
                              'Upload Image', 
                              style: TextStyle(color: Colors.white)
                            )
                          ),
                        ],
                      )
                    ),

                    const Divider(indent: 2, height: 50),

                    const Text(
                      'Trailing Icon',
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
                        onPressed: trailingIconPicker,
                        icon: Icon(getIconData('trailing')),
                        style: const ButtonStyle(
                          maximumSize: WidgetStatePropertyAll(Size(100, 100))
                        ),
                      ),
                    ),
  
                    const SizedBox(height: 20),
                    
                    MyFormGroup(
                      type: 'picker',
                      name: "Trailing Color",
                      iconColor: getColorPoint('trailing','color'),
                      onTap: () => colorPickerDialog(
                        context,
                        getColorPoint('trailing','color'),
                        trailingIconChangeColor,
                        () {
                          
                          Get.back();
                        }
                      )
                    ),

                  ],
                )
              )
            ]
          )
        ]
      )
    );
  }


  Future updatePreview(type, isMultiple, isPreview) async {

    FileType? theType;

    switch(type) {
      case'images':
        theType = FileType.image;
        break;
      case 'audios':
        theType = FileType.audio;
        break;
      default:
    }
 
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: theType ?? FileType.any,
      allowMultiple: isMultiple,

    );

    if (result != null) {
      final file = result.files.first;
      // ignore: unused_local_variable
      Uint8List fileBytes = file.bytes as Uint8List;
      // ignore: unused_local_variable
      String fileName = file.name;
      
      if(type == 'images') {

        settings.imageUpload.add(file);

        setState(() {
          formFile = file;
        });

        settings.newDetails.update((item) {
          item?.image = fileName;
        });
        
        setState(() {
          featureImage = Image.memory(fileBytes, fit: BoxFit.cover);
        });
      }
    }
  }

}