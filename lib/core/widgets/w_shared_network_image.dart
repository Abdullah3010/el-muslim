import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WCachedImage extends StatelessWidget {
  const WCachedImage({
    required this.imageUrl,
    super.key,
    this.errorIcon = const Icon(Icons.broken_image_sharp, size: 15, color: Colors.black38),
    this.errorWidget,
    this.loaderIcon = const CircularProgressIndicator.adaptive(),
    this.color,
    this.backgroundColor,
    this.width,
    this.height,
    this.displayLoader,
    this.displayException,
    this.onExceptionTap,
    this.placeHolder,
    this.fit = BoxFit.cover,
    this.radius = 0.0,
    this.loaderColor = Colors.white,
    this.errorColor = Colors.white,
    this.cacheKey,
    this.imageBuilder,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final double radius;
  final Widget errorIcon;
  final Widget? errorWidget;
  final Color? color;
  final Color? backgroundColor;
  final Color? loaderColor;
  final Widget loaderIcon;
  final Widget? placeHolder;
  final Color? errorColor;
  final bool? displayLoader;
  final bool? displayException;
  final Function()? onExceptionTap;
  final BoxFit fit;
  final String? cacheKey;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.contains('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: width,
        height: height,
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        placeholderBuilder: (ctx) => SizedBox(width: width, height: height, child: Center(child: loaderIcon)),
      );
    }

    return Stack(
      children: [
        if (backgroundColor != null)
          Positioned.fill(
            child: ColoredBox(color: backgroundColor ?? Colors.black),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            key: ValueKey(imageUrl),
            cacheKey: cacheKey ?? imageUrl,
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            fadeInDuration: const Duration(milliseconds: 100),
            imageBuilder: imageBuilder ??
                (context, imageProvider) {
                  return Image(image: imageProvider, fit: fit);
                },
            placeholder: (ctx1, url) {
              return SizedBox(
                width: width,
                height: height,
                child: placeHolder ??
                    const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
              );
            },
            errorWidget: (ctx2, url, error) {
              return errorWidget ??
                  GestureDetector(
                    onTap: () {
                      if (onExceptionTap != null) {
                        onExceptionTap?.call();
                      } else {
                        CachedNetworkImage.evictFromCache(url);
                      }
                    },
                    child: Container(
                      color: errorColor?.withValues(alpha: .5),
                      width: width,
                      height: height,
                      child: Center(child: errorIcon),
                    ),
                  );
            },
          ),
        ),
        if (displayLoader ?? false) const CupertinoActivityIndicator(),
        if (displayException ?? false)
          Positioned.fill(
            child: InkWell(
              onTap: () {
                onExceptionTap?.call();
              },
              child: Center(
                child: Icon(
                  Icons.refresh,
                  color: Colors.red,
                  size: (width ?? 200) * .1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
