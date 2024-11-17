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
    final isMobileMode = enforceMobileMode || !FluffyThemes.isColumnMode(context);

    // cache-busting parameter
    final cacheBustParam = AppConfig.version;

    return Container(
      decoration: AppConfig.enableBGImage
          ? BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                // Add cache-busting parameter to the image URL
                image: NetworkImage(
                  'assets/assets/login-bg.jpg?cache_bust=$cacheBustParam',
                ),
              ),
            )
          : BoxDecoration(
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
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  clipBehavior: Clip.hardEdge,
                  elevation: theme.appBarTheme.scrolledUnderElevation ?? 4,
                  shadowColor: theme.appBarTheme.shadowColor,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: Scaffold(
                      key: const Key('LoginScaffold'),
                      appBar: appBar,
                      body: SafeArea(child: body),
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
    final theme = Theme.of(context);
    final shadowTextStyle = TextStyle(color: theme.colorScheme.secondary);
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            TextButton(
              onPressed: () => launchUrlString(AppConfig.website),
              child: Text(
                L10n.of(context).website,
                style: shadowTextStyle,
              ),
            ),
            TextButton(
              onPressed: () => launchUrlString(AppConfig.supportUrl),
              child: Text(
                L10n.of(context).help,
                style: shadowTextStyle,
              ),
            ),
            TextButton(
              onPressed: () => launchUrlString(AppConfig.privacyUrl),
              child: Text(
                L10n.of(context).privacy,
                style: shadowTextStyle,
              ),
            ),
            TextButton(
              onPressed: () => PlatformInfos.showDialog(context),
              child: Text(
                L10n.of(context).about,
                style: shadowTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
