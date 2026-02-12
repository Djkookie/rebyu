import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/components/form_group.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';


class AddNewItem extends StatefulWidget {
  const AddNewItem({super.key, required this.items});

  final List<dynamic> items;

  @override
  AddNewItemState createState() => AddNewItemState();
}

class AddNewItemState extends State<AddNewItem> {

  final AdminController settings = Get.find();

  var title = ''.obs, link = ''.obs;

  RxBool isErrorTitle = false.obs;
  RxBool isErrorLink = false.obs;


  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.deepOrange.withOpacity(0.7)),
        overlayColor: const WidgetStatePropertyAll(Colors.deepOrange),
        textStyle:const WidgetStatePropertyAll(TextStyle(
          color: Colors.white
        ))
      ),
      label: const Text(
        'Add Item',
        style: TextStyle(
          color: Colors.white
        ),
      ),
      onPressed: () => {
        showDialog(
          
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Add Social Item',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
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
              content: SingleChildScrollView(
                child: Obx(() => ListBody(
                  children: [
                    MyFormGroup(
                      placeholder: 'Title',
                      onChange: (value) {
                        title.value = value;
                      }
                    ),
                    (isErrorTitle.isTrue) ? const Text('Title is Required', style: TextStyle(color: Colors.red))  : const SizedBox.shrink(),
                    const SizedBox(height: 10),
                    MyFormGroup(
                      name: 'Redirect Link',
                      borderColor: Colors.grey,
                      isMultiple: true,
                      rows: 5,
                      onChange: (value) {
                        link.value = value;
                      },
                    ),
                    (isErrorLink.isTrue) ? const Text('Link is Required', style: TextStyle(color: Colors.red))   : const SizedBox.shrink(),
                  ],
                )),
              ),
              actionsPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              actionsAlignment: MainAxisAlignment.end,
              buttonPadding: const EdgeInsets.symmetric(vertical: 20),
              actions: [
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.white
                    )
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.blue[800])),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {

                    bool isValid = true;

                    if(title.value.isEmpty) {
                      isErrorTitle.value = true;
                      isValid = false;
                    } else {
                      isErrorTitle.value = false;
                    }

                    if(link.value.isEmpty) {
                      isErrorLink.value = true;
                      isValid = false;
                    } else {
                      isErrorLink.value = false;
                    }

                    if(isValid) {
                      settings.setNewItem(title.value, link.value);
                      Get.back();
                    }
                  
                  },
                  child: const Text('Submit', style: TextStyle(color: Colors.white))
                )
              ]
            );
          },
        )
      },
      icon: const Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
    );
    
  }
}