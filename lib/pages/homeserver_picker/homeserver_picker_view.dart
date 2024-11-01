import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../config/themes.dart';
import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {super.key});

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
              top: 64.0,
              bottom: 16.0,
              left: 64.0,
              right: 64.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width < 450 ? 
                  MediaQuery.of(context).size.width * 1 : MediaQuery.of(context).size.width * 0.6,
              ),
              child: Image.asset(
                'assets/banner_transparent.png',
                alignment: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: FractionallySizedBox(
              widthFactor: MediaQuery.of(context).size.width < 450 ? 0.9 : 0.7, // % of the parent
              child: SizedBox(
                height: 56,
                child: TextField(
                controller: controller.homeserverController,
                autocorrect: false,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(34.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: AppConfig.defaultHomeserver,
                  errorText: controller.error,
                  contentPadding: const EdgeInsets.all(16.0),
                ),
              ),
              ),
            ),
          ),
          if (MediaQuery.of(context).size.height > 512) const Spacer(),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 64.0,
            ),
            children: [
              FractionallySizedBox(
                widthFactor: MediaQuery.of(context).size.width < 450 ? 0.6 : 0.4, // % width of the parent
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: controller.isLoggingIn || controller.isLoading
                      ? null
                      : controller.checkHomeserverAction,
                  child: Text(L10n.of(context)!.next),
                ),
              ),
              const SizedBox(height: 16.0),
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
