import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluffychat/config/app_config.dart';

class FallbackImage extends StatelessWidget {
  final String svgPath;
  final String pngPath;

  const FallbackImage({
    required this.svgPath,
    required this.pngPath,
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

  @override
  Widget build(BuildContext context) {
    final cacheBustParam = AppConfig.version;
    return FutureBuilder<bool>(
      key: ValueKey(cacheBustParam),
      future: _assetExists(svgPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return SvgPicture.asset(
              svgPath,
              alignment: Alignment.center,
            );
          } else {
            return Image.asset(
              pngPath,
              alignment: Alignment.center,
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
