import 'dart:math';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jovial_svg/jovial_svg.dart';

class EmptyPage extends StatelessWidget {
  static const double _width = 400;
  const EmptyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, EmptyPage._width) / 2;
    final theme = Theme.of(context);
    final cacheBustParam = AppConfig.version;
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        alignment: Alignment.center,
        // child: Image.asset(
        //   'assets/logo_transparent.png',
        //   key: ValueKey(cacheBustParam),
        //   color: theme.colorScheme.surfaceContainerHigh,
        //   width: width,
        //   height: width,
        //   filterQuality: FilterQuality.medium,
        // ),
        child: AppConfig.logoType == "png" 
            ? Image.network(
                'assets/assets/logo_transparent.png?cache_bust=$cacheBustParam',
                color: theme.colorScheme.surfaceContainerHigh,
                width: width,
                height: width,
              )
            : SizedBox(
                width: width,
                height: width,
                child: ScalableImageWidget.fromSISource(
                  si: ScalableImageSource.fromSvgHttpUrl(
                    Uri.parse(
                      'assets/assets/logo_transparent.svg?cache_bust=$cacheBustParam',
                    ),
                  ),
                  onError: (context) => SvgPicture.asset(
                    'assets/logo_transparent.svg',
                    width: width,
                    height: width,
                  ),
                ),
            ),
      ),
    );
  }
}
