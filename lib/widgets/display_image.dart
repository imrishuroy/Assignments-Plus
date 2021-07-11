import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/widgets/loading_indicator.dart';

class DisplayImage extends StatelessWidget {
  final String? imageUrl;
  final double errorIconSize;

  const DisplayImage(
    this.imageUrl, {
    this.errorIconSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl!.isEmpty
        ? Icon(Icons.image_not_supported_sharp)
        : CachedNetworkImage(
            fit: BoxFit.cover,
            placeholder: (context, _) => const LoadingIndicator(
              size: 10.0,
            ),
            // progressIndicatorBuilder: (context, url, downloadProgress) =>
            //     SizedBox(
            //   height: 10.0,
            //   width: 10.0,
            //   child: CircularProgressIndicator(
            //     value: downloadProgress.progress,
            //     strokeWidth: 3.0,
            //   ),
            // ),
            imageUrl: imageUrl!,

            errorWidget: (context, _, __) => Icon(
              Icons.error,
              size: errorIconSize,
            ),
          );
  }
}
