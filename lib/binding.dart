import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';

class AppBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => AdminController());
  }
}