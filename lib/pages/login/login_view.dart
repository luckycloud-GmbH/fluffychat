import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final homeserver = Matrix.of(context)
        .getLoginClient()
        .homeserver
        .toString()
        .replaceFirst('https://', '');
    final title = L10n.of(context).logInTo(homeserver);
    final titleParts = title.split(homeserver);

    return LoginScaffold(
      enforceMobileMode: Matrix.of(context).client.isLogged(),
      appBar: null,
      body: Builder(
        builder: (context) {
          return AutofillGroup(
            child: Column(
              // padding: const EdgeInsets.symmetric(horizontal: 8),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 64.0,
                    bottom: 6.0,
                    left: 48.0,
                    right: 48.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: 100,
                    ),
                    // child: Image.asset(
                    //   'assets/banner_transparent.svg',
                    //   alignment: Alignment.center,
                    // ),
                    child: SvgPicture.asset(
                      'assets/banner_transparent.svg',
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextField(
                      readOnly: controller.loading,
                      autocorrect: false,
                      autofocus: true,
                      onChanged: controller.checkWellKnownWithCoolDown,
                      controller: controller.usernameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints:
                          controller.loading ? null : [AutofillHints.username],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(34.0),
                          borderSide: BorderSide.none,
                        ),
                        errorText: controller.usernameError,
                        errorStyle: const TextStyle(color: Colors.orange),
                        hintText: L10n.of(context)!.emailOrUsername,
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextField(
                      readOnly: controller.loading,
                      autocorrect: false,
                      autofillHints:
                          controller.loading ? null : [AutofillHints.password],
                      controller: controller.passwordController,
                      textInputAction: TextInputAction.go,
                      obscureText: !controller.showPassword,
                      onSubmitted: (_) => controller.login(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(34.0),
                          borderSide: BorderSide.none,
                        ),
                        errorText: controller.passwordError,
                        errorStyle: const TextStyle(color: Colors.orange),
                        hintText: L10n.of(context)!.password,
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 54),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FractionallySizedBox(
                    widthFactor: MediaQuery.of(context).size.width < 450 ? 0.6 : 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryColor,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      onPressed: controller.loading ? null : controller.login,
                      child: controller.loading
                          ? const LinearProgressIndicator()
                          : Text(L10n.of(context)!.login),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FractionallySizedBox(
                  widthFactor: MediaQuery.of(context).size.width < 450 ? 0.6 : 0.4,
                    child: TextButton(
                      onPressed: controller.loading
                          ? () {}
                          : controller.passwordForgotten,
                      style: TextButton.styleFrom(
                        textStyle: theme.textTheme.labelMedium,
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      child: Text(L10n.of(context)!.passwordForgotten),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
