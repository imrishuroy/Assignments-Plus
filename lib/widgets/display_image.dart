import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final String? imageUrl;

  const DisplayImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        height: 50.0,
        width: 50.0,
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
        ),
      ),
      imageUrl: imageUrl!,
      errorWidget: (context, _, __) => Icon(Icons.error),
    );
  }
}
