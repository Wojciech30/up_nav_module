import 'package:flutter/material.dart';

class BuildingImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  const BuildingImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final image = (imageUrl == null || imageUrl!.isEmpty)
        ? Image.asset(
      'assets/placeholder/PlaceHolder.png',
      width: width,
      height: height,
      fit: fit,
    )
        : Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/placeholder/PlaceHolder.png',
        width: width,
        height: height,
        fit: fit,
      ),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
