import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImageView extends StatelessWidget {
  const CustomImageView({
    super.key,
    this.path = "",
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.margin,
    this.padding,
    this.border,
    this.borderRadius = BorderRadius.zero,
    this.color,
    this.isFileImage = false,
  });

  final String path;

  final double? width;
  final double? height;

  final BoxFit fit;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;

  final Color? color;

  final bool isFileImage;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: _getImageWidget(path, context),
      ),
    );
  }

  Widget _getImageWidget(String url, BuildContext context) {
    if (url.startsWith("http") || url.startsWith("https") || url.startsWith("www")) {
      if (url.endsWith(".svg")) {
        return SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: fit,
          colorFilter: ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => SizedBox(
            height: height,
            width: width,
            child: const Center(child: CircularProgressIndicator()),
          ),
          color: color,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          width: width,
          height: height,
          fit: fit,
        );
      }
    } else {
      if (url.endsWith(".svg")) {
        return SvgPicture.asset(
          url,
          width: width,
          height: height,
          fit: fit,
          colorFilter: ColorFilter.mode(color ?? Colors.black, BlendMode.srcIn),
        );
      } else if (isFileImage) {
        return Image.file(
          File(url),
          width: width,
          height: height,
          fit: fit,
          color: color,
        );
      } else {
        return Image.asset(
          url,
          width: width,
          height: height,
          fit: fit,
          color: color,
        );
      }
    }
  }
}
