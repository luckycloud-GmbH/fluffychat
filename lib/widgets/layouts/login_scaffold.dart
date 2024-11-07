import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class LoginScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final bool enforceMobileMode;

  const LoginScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.enforceMobileMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isMobileMode =
        enforceMobileMode || !FluffyThemes.isColumnMode(context);
    final scaffold = Scaffold(
      key: const Key('LoginScaffold'),
      appBar: appBar == null
          ? null
          : AppBar(
              titleSpacing: appBar?.titleSpacing,
              automaticallyImplyLeading:
                  appBar?.automaticallyImplyLeading ?? true,
              centerTitle: appBar?.centerTitle,
              title: appBar?.title,
              leading: appBar?.leading,
              actions: appBar?.actions,
              backgroundColor: Colors.transparent,
            ),
      body: SafeArea(child: body),
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      // bottomNavigationBar: isMobileMode
      //     ? Material(
      //         elevation: 4,
      //         shadowColor: theme.colorScheme.onSurface,
      //         child: const SafeArea(
      //           child: _PrivacyButtons(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //           ),
      //         ),
      //       )
      //     : null,
    );
    // if (isMobileMode) return scaffold;
    return Container(
      decoration: AppConfig.enableBGImage ?
        BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(AppConfig.defaultBGImage),
          ),
        ) : BoxDecoration(
          color: AppConfig.backgroundColor,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  clipBehavior: Clip.hardEdge,
                  elevation: theme.appBarTheme.scrolledUnderElevation ?? 4,
                  shadowColor: theme.appBarTheme.shadowColor,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500, maxHeight: 520),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10.0,
                        sigmaY: 10.0,
                      ),
                      child: scaffold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const _PrivacyButtons(mainAxisAlignment: MainAxisAlignment.center),
        ],
      ),
    );
  }
}

class _PrivacyButtons extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  const _PrivacyButtons({required this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    final shadowTextStyle = FluffyThemes.isColumnMode(context)
        ? const TextStyle(
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0.0, 0.0),
                blurRadius: 3,
                color: Colors.black,
              ),
            ],
          )
        : null;
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            TextButton(
              onPressed: () => PlatformInfos.showDialog(context),
              child: Text(
                L10n.of(context)!.about,
                style: shadowTextStyle,
              ),
            ),
            TextButton(
              onPressed: () => launchUrlString(AppConfig.privacyUrl),
              child: Text(
                L10n.of(context)!.privacy,
                style: shadowTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
