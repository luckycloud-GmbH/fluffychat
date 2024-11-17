import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../config/themes.dart';
import 'homeserver_picker.dart';
import '../../utils/image_fallback.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LoginScaffold(
      enforceMobileMode: Matrix.of(context).client.isLogged(),
      appBar: controller.widget.addMultiAccount
          ? AppBar(
              centerTitle: true,
              title: Text(L10n.of(context)!.addAccount),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // display a prominent banner to import session for TOR browser
          // users. This feature is just some UX sugar as TOR users are
          // usually forced to logout as TOR browser is non-persistent
          AnimatedContainer(
            height: controller.isTorBrowser ? 64 : 0,
            duration: FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            child: Material(
              clipBehavior: Clip.hardEdge,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
              color: theme.colorScheme.surface,
              child: ListTile(
                leading: const Icon(Icons.vpn_key),
                title: Text(L10n.of(context)!.hydrateTor),
                subtitle: Text(L10n.of(context)!.hydrateTorLong),
                trailing: const Icon(Icons.chevron_right_outlined),
                onTap: controller.restoreBackup,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 48.0,
              bottom: 16.0,
              left: 48.0,
              right: 48.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: 80,
              ),
              child: AppConfig.logo_type == "png" ?  Image.asset(
                  'assets/banner_transparent.png',
                  alignment: Alignment.center,
                ) : SvgPicture.asset(
                  'assets/banner_transparent.svg',
                  alignment: Alignment.center,
                ),
              // child: const FallbackImage(
              //   svgPath: 'assets/banner_transparent.svg',
              //   pngPath: 'assets/banner_transparent.png',
              // ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(32.0),
          //   child: FractionallySizedBox(
          //     widthFactor: 0.8, // % of the parent
          //     child: TextField(
          //       controller: controller.homeserverController,
          //       autocorrect: false,
          //       keyboardType: TextInputType.url,
          //       decoration: InputDecoration(
          //         filled: true,
          //         fillColor: theme.colorScheme.surfaceContainerHighest,
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(34.0),
          //           borderSide: BorderSide.none,
          //         ),
          //         hintText: AppConfig.defaultHomeserver,
          //         errorText: controller.error,
          //         errorStyle: const TextStyle(color: Colors.orange),
          //         contentPadding: const EdgeInsets.all(16.0),
          //       ),
          //     ),
          //   ),
          // ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 48.0,
            ),
            children: [
              // const SizedBox(height: 32),
              FractionallySizedBox(
                widthFactor: MediaQuery.of(context).size.width < 450 ? 0.6 : 0.4, // % width of the parent
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: controller.isLoggingIn || controller.isLoading
                      ? null
                      : controller.login,
                  child: Text(L10n.of(context)!.login),
                ),
              ),
              const SizedBox(height: 64.0),
              controller.supportsSso
              ? FractionallySizedBox(
                widthFactor: MediaQuery.of(context).size.width < 450 ? 0.6 : 0.4, // % width of the parent
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: controller.isLoggingIn || controller.isLoading
                      ? null
                      : controller.ssoLoginAction,
                  child: Text(L10n.of(context)!.singlesignon),
                ),
              )
              : const SizedBox(height: 56),
              const SizedBox(height: 32.0),
              FractionallySizedBox(
                widthFactor: MediaQuery.of(context).size.width < 450 ? 0.6 : 0.4, // % width of the parent
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: theme.textTheme.labelMedium,
                    foregroundColor: theme.colorScheme.onSurface,
                  ),
                  onPressed: controller.isLoggingIn || controller.isLoading
                      ? null
                      : controller.restoreBackup,
                  child: Text(L10n.of(context)!.hydrate),
                ),
              ),              
            ],
          ),
        ],
      ),
    );
  }
}
