import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluffychat/config/app_config.dart';

class FallbackImage extends StatelessWidget {
  final String path;

  const FallbackImage({
    required this.path,
    Key? key,
  }) : super(key: key);

  Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isSvg(String path) {
    return path.toLowerCase().endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    final cacheBustParam = AppConfig.version;
    return FutureBuilder<bool>(
      key: ValueKey(cacheBustParam),
      future: _assetExists(path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            // Display SVG if the file is SVG, otherwise display as image
            if (_isSvg(path)) {
              return SvgPicture.asset(
                path,
                alignment: Alignment.center,
              );
            } else {
              return Image.asset(
                path,
                alignment: Alignment.center,
              );
            }
          } else {
            // Fallback to placeholder if the asset doesn't exist
            return const Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.grey,
            );
          }
        }
        // Show a placeholder or loading widget while the future is being resolved
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
