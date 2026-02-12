import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';

class Sites extends StatefulWidget {
  const Sites({super.key});

  @override
  State<Sites> createState() => _SitesState();
}

class _SitesState extends State<Sites> {

  AdminController admin = Get.find();

  List sites = <String>[
    'asdigital',
    'hairfeather',
  ];

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(

          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (__,_) => const SizedBox(height: 10),
            itemCount: sites.length,
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                title: Text(sites[index].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)),
                tileColor: Colors.white,
                // selectedTileColor: Colors.blueAccent,
                textColor: Colors.black,
                selectedColor: Colors.white,
                hoverColor: Colors.blueAccent.shade700,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                trailing: const Icon(Icons.arrow_circle_right_outlined),
                onTap: () {
                  admin.refresh();
                  admin.onInit();
                  Get.offAllNamed('/dashboard?site=${sites[index]}');
                  // admin.onInit();
                },
              );
            }
          )
        )
      )
    );
  }
}
