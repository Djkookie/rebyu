import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/components/fields_group.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {


  late TabController tabControl;

  final AdminController settings = Get.find();

  // var tabKey = UniqueKey().toString().obs;

  List styleType = [
    {
      'id': 'style 1',
      'name' : 'Style 1',
      
    },
    {
      'id': 'style 2',
      'name' : 'Style 2',
      
    },
    {
      'id': 'style 3',
      'name' : 'Style 3',
      
    }
  ];

  void restartKey() {

  }


  @override
  void initState() {

    tabControl = TabController(length: 3, vsync: this, animationDuration: Duration.zero);

    // tabControl.addListener(() => setState(() {
    //   tabKey.value = UniqueKey().toString();
    // }));
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton.icon(
            onPressed: () {

              settings.updatePagesData(settings.pagesData).whenComplete(() {
                Get.snackbar(
                  'Page Data',
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
                  forwardAnimationCurve: Curves.bounceInOut
                );
              });

              if(settings.imageUpload.isNotEmpty) {

                final formFile = settings.imageUpload.first;
                final fileName = settings.imageUpload.first.name;
                Uint8List fileBytes = formFile?.bytes as Uint8List;
                settings.uploadFileData('images', fileName, fileBytes);
              }
            },

            label: const Text('Update'),
            icon: const Icon(Icons.save),
          ),
        ],
        bottom: TabBar(
        
          controller: tabControl,
          overlayColor: const WidgetStatePropertyAll(Colors.white),
          dividerColor: Colors.transparent,
          labelColor: Colors.deepOrange,
          tabAlignment: TabAlignment.center,
          tabs: const [
            Tab(
              icon: Icon(Icons.label_important_rounded),
              child: Text(
                'Home Page',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.label_important_rounded),
              child: Text(
                'Form Page',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.label_important_rounded),
              child: Text(
                'Thank you Page',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),

      body: TabBarView(
        // key: Key(tabKey.value),
        controller: tabControl,
        children: [
          Container(
            color: Colors.white,
            child: FieldsGroup(
              id: 'home',
              list: styleType,
              title: 'Yes and No (Page Title)',
              subtitle: 'Style'
            ),
          ),

          Container(
            color: Colors.white,
            child: FieldsGroup(
              id: 'form',
              list: styleType,
              title: 'Complaint Form (Page Title)',
              subtitle: 'Style'
            ),
          ),

          Container(
            color: Colors.white,
            child: FieldsGroup(
              id: 'thankyou',
              list: styleType,
              title: 'Thank You (Page Title)',
              subtitle: 'Style'
            ),
          ),
        ],
      ),
    );
  }
}