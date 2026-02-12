import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';

class ImagePath extends StatefulWidget {
  final String image;
  final double? height;
  final double? width;
  const ImagePath({
    super.key,
    required this.image,
    this.height,
    this.width
  });

  @override
  State<StatefulWidget> createState() => ImagePathState();
}

class ImagePathState extends State<ImagePath>{

  Future? _future;

  late WidgetBuilder cacheImage;

  @override
  void initState() {

    _future = _init();

    super.initState();
  }

  Future _init() async {
    return await Get.find<AdminController>().getFileDownloadPath('images', widget.image);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {

          // ignore: avoid_print
          print('SNAPSHOT SNAPSHOT ${snapshot.data}');

          if(snapshot.connectionState == ConnectionState.done) {

            String? imagePath = snapshot.data;

            if(imagePath != null) {

              return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  height: widget.height,
                  width:  widget.width,
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    child: CachedNetworkImage(
                      progressIndicatorBuilder: (context, url, progress) => Center(
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                value: progress.progress,
                                strokeWidth: 2.5,
                              )
                          )

                      ),
                      imageUrl: imagePath.toString(),
                      fit: BoxFit.cover,
                    )
                  )
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
