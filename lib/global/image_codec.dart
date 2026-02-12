import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';

class ImageCodec extends StatefulWidget {
  final String image;
  final double? height;
  final double? width;
  const ImageCodec({
    super.key,
    required this.image,
    this.height,
    this.width
  });

  @override
  State<StatefulWidget> createState() => ImageCodecState();
}

class ImageCodecState extends State<ImageCodec>{

  Future? _future;

  late WidgetBuilder cacheImage;

  @override
  void initState() {

    _future = _init();

    super.initState();
  }

  Future _init() async {

    return await Get.find<AdminController>().getFileStoragePath('images', widget.image);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.done) {

            String? imagePath = snapshot.data;

            if(imagePath != null) {

              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
                height: widget.height ?? double.maxFinite,
                width: widget.width ?? double.maxFinite,
                child: Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Image.network(imagePath.toString(), fit: BoxFit.cover)
                ),
              );

            } else {
              return Image.asset("lib/assets/images/unknown_img.png", fit: BoxFit.cover);
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
