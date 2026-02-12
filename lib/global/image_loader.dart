import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';


class ImageLoader extends StatefulWidget {
  const ImageLoader({
    super.key,
    required this.image,
    this.width,
    this.height
  });
  final String image;
  final double? width;
  final double? height;

  @override
  State<StatefulWidget> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  Future<Uint8List?>? future;

  final AdminController settings = Get.find();

  @override
  void initState() {
    future = _init();
    super.initState();
  }

  Future<Uint8List?> _init() async => await settings.getFileBytes('images', widget.image).catchError((e) {
    // ignore: avoid_print
    print('ERROR $e');
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: future,
      builder: (context, snapshot) {
        
        Widget assetImage = Image.asset("lib/assets/images/unknown_img.png", fit: BoxFit.fill) ;
    
        if(snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Image.memory(snapshot.data!, fit: BoxFit.cover);
            } else {
              return assetImage;
            }
          } else {
            return assetImage;
          }
        }

        return Center(
          child: SizedBox(
            width: widget.width ?? 20,
            height: widget.height ?? 20,
            child: const CircularProgressIndicator(strokeWidth: 3)
          )
        );
      }
    );
  }
}