import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/admin/dashboard.dart';

class AppSystem extends GetView<AdminController> {
  const AppSystem({super.key});
 
  @override
  Widget build(BuildContext context) {
    // Get.put(() => AdminController());
    return StreamBuilder(stream: controller.connectDatabaseVAlue(), builder: (context, snapshot) {

      if(snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {

        DatabaseEvent? snapData = snapshot.data;

        final data = snapData?.snapshot.children;

        List newList = [], newKeys = [];

        if(data != null) {

          for (DataSnapshot item in data) {
              Map itemValue = item.value as Map;
              var newMap = itemValue.map((key, value) => MapEntry(key.toString(), value as dynamic));
              newList.add(newMap);
              newKeys.add(item.key);
          }
        }

        controller.socialData.assignAll(newList);
        controller.socialDataFront.assignAll(newList);

        return const WebContentWrapper();
      }

      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );

    });
  }
}