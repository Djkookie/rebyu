import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/admin/dashboard.dart';
import 'package:rebyu/admin/route.dart';
import 'package:rebyu/admin/sites.dart';
import 'package:rebyu/lang/languages.dart';
import 'package:rebyu/public/complaint_form.dart';
import 'package:rebyu/public/home.dart';
import 'package:rebyu/public/login.dart';
import 'package:rebyu/public/social_list.dart';
import 'package:rebyu/public/thankyou.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put<AdminController>(AdminController());
  // GoogleFonts.config.allowRuntimeFetching = false;
  // setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends GetView<AdminController> {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslation(),
      debugShowCheckedModeBanner: false,
      routes: <String, Widget Function(BuildContext)>{
        ExtractRouteArguments.routeName: (_) => const ExtractRouteArguments()
      },
      initialRoute: (controller.userId == null) ? '/' : '/dashboard',
      // unknownRoute: GetPage(name: '/mylogin', page: () => const AppLogin()),
      // onGenerateRoute: (RouteSettings route) {
      //   var uri = Uri.parse(route.name!);
      //   switch (uri.path) {
      //     case "/login":
      //       return MaterialPageRoute(
      //         settings: route,
      //         builder: (context) => const AppLogin(),
      //       );

      //     case "/":
      //       return MaterialPageRoute(
      //         settings: route,
      //         builder: (context) => const AppLogin(),
      //    );
      //     default:
      //       return MaterialPageRoute(
      //         settings: route,
      //         builder: (context) => const HomePublic(),
      //       );
      //   }
      // },
      getPages: [
        GetPage(
          name: '/redirects',
          page: () => const SocialList(),
          // maintainState: false,
          // preventDuplicates: false
        ),
        GetPage(
          name: '/',
          page: () => const HomePublic(),
          // maintainState: false,
          // preventDuplicates: false
        ),
        GetPage(
          name: '/sites',
          page: () => const Sites(),
        ),
        GetPage(
          name: '/thankyou',
          page: () => const ThankYouPage(),
        ),
        GetPage(
          name: '/complaint',
          page: () => const ComplaintForm(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const WebContentWrapper(),
        ),
        GetPage(
          name: '/mylogin',
          page: () => const AppLogin(),
          opaque: false
        ),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}