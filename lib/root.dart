import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/app.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/public/home.dart';

class Root extends GetWidget<AdminController>{
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return (controller.userId == '') ? const HomePublic() : const AppSystem();
  }
}