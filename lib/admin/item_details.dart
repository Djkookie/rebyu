import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/admin/details.dart';

class ItemDetails extends GetView<AdminController> {
  const ItemDetails({super.key, required this.id});

  final String id;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: controller.getItemData(id), builder: (context, snapshot) {

      if(snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {

        DatabaseEvent snapData = snapshot.data;

        Map<String, dynamic> data = snapData.snapshot.value as Map<String, dynamic>;

        // ignore: avoid_print
        print('DATA DATA $data');
        return ItemDetailsPage(item: data);

      }
      // ignore: avoid_print
      return const Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Center(child: CircularProgressIndicator())
      );

    });
  }
}