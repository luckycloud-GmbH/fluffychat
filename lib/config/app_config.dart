import 'dart:ui';

import 'package:matrix/matrix.dart';

abstract class AppConfig {
  static String _applicationName = 'luckyChat';
  static String get applicationName => _applicationName;
  static String? _applicationWelcomeMessage;
  static String? get applicationWelcomeMessage => _applicationWelcomeMessage;
  static String _defaultHomeserver = 'dev.etke.host';
  static String get defaultHomeserver => _defaultHomeserver;
  static double fontSizeFactor = 1;
  static Color chatColor = primaryColor;
  static Color? colorSchemeSeed = primaryColor;
  static const double messageFontSize = 16.0;
  static const bool allowOtherHomeservers = true;
  static const bool enableRegistration = true;
  static bool enableBGImage = false;
  // static String _defaultBGImage = 'https://dev-chat.lc-testing.de/assets/assets/login-bg.jpg';
  // static String get defaultBGImage => _defaultBGImage;
  static String _version = '1.0.0';
  static String get version => _version;
  static Color primaryColor = Color(0xFF42D75F);
  static const Color primaryColorLight = Color(0xFFcdeaba);
  static const Color secondaryColor = Color(0xFFADADAD);
  static Color backgroundColor = Color(0xFF008000);

  static String _privacyUrl =
      'https://docs.luckycloud.de/de/data-protection-and-security';
  static String get privacyUrl => _privacyUrl;
  static const String website = 'https://fluffychat.im';
  static const String enablePushTutorial =
      'https://github.com/luckycloud-GmbH/luckychat/wiki/Push-Notifications-without-Google-Services';
  static const String encryptionTutorial =
      'https://github.com/luckycloud-GmbH/luckychat/wiki/How‐to‐use‐end‐to‐end‐encryption‐in‐luckychat';
  static const String startChatTutorial =
      'https://github.com/luckycloud-GmbH/luckychat/wiki/How‐to‐Find‐Users‐in‐luckychat';
  static const String appId = 'im.fluffychat.FluffyChat';
  static const String appOpenUrlScheme = 'im.fluffychat';
  static String _webBaseUrl = 'https://fluffychat.im/web';
  static String get webBaseUrl => _webBaseUrl;
  static const String sourceCodeUrl =
      'https://github.com/luckycloud-GmbH/luckychat';
  static const String supportUrl =
      'https://luckycloud.de/de/support-center';
  static const String changelogUrl =
      'https://docs.luckycloud.de/de/changelogs';
  static final Uri newIssueUrl = Uri(
    scheme: 'https',
    host: 'github.com',
    path: '/krille-chan/fluffychat/issues/new',
  );
  static bool renderHtml = true;
  static bool hideRedactedEvents = false;
  static bool hideUnknownEvents = true;
  static bool hideUnimportantStateEvents = true;
  static bool separateChatTypes = false;
  static bool autoplayImages = true;
  static bool sendTypingNotifications = true;
  static bool sendPublicReadReceipts = true;
  static bool swipeRightToLeftToReply = true;
  static bool? sendOnEnter;
  static bool showPresences = true;
  static bool experimentalVoip = false;
  static const bool hideTypingUsernames = false;
  static const bool hideAllStateEvents = false;
  static const String inviteLinkPrefix = 'https://matrix.to/#/';
  static const String deepLinkPrefix = 'im.fluffychat://chat/';
  static const String schemePrefix = 'matrix:';
  static const String pushNotificationsChannelId = 'fluffychat_push';
  static const String pushNotificationsAppId = 'chat.fluffy.fluffychat';
  static const String pushNotificationsGatewayUrl =
      'https://push.fluffychat.im/_matrix/push/v1/notify';
  static const String pushNotificationsPusherFormat = 'event_id_only';
  static const String emojiFontName = 'Noto Emoji';
  static const String emojiFontUrl =
      'https://github.com/googlefonts/noto-emoji/';
  static const double borderRadius = 18.0;
  static const double columnWidth = 360.0;
  static final Uri homeserverList = Uri(
    scheme: 'https',
    host: 'servers.joinmatrix.org',
    path: 'servers.json',
  );

  static void loadFromJson(Map<String, dynamic> json) {
    if (json['chat_color'] != null) {
      try {
        colorSchemeSeed = Color(json['chat_color']);
      } catch (e) {
        Logs().w(
          'Invalid color in config.json! Please make sure to define the color in this format: "0xFF42d75f"',
          e,
        );
      }
    }
    if (json['application_name'] is String) {
      _applicationName = json['application_name'];
    }
    if (json['application_welcome_message'] is String) {
      _applicationWelcomeMessage = json['application_welcome_message'];
    }
    if (json['default_homeserver'] is String) {
      _defaultHomeserver = json['default_homeserver'];
    }
    if (json['privacy_url'] is String) {
      _privacyUrl = json['privacy_url'];
    }
    if (json['web_base_url'] is String) {
      _webBaseUrl = json['web_base_url'];
    }
    if (json['render_html'] is bool) {
      renderHtml = json['render_html'];
    }
    if (json['hide_redacted_events'] is bool) {
      hideRedactedEvents = json['hide_redacted_events'];
    }
    if (json['hide_unknown_events'] is bool) {
      hideUnknownEvents = json['hide_unknown_events'];
    }
    // custom color and bg image
    if (json['enable_bg_image'] is bool) {
      enableBGImage = json['enable_bg_image'];
    }
    // if (json['default_bg_image'] is String) {
    //   _defaultBGImage = json['default_bg_image'];
    // }
    if (json['version'] is String) {
      _version = json['version'];
    }
    if (json['primary_color'] != null) {
      primaryColor = Color(json['primary_color']);
    }
    if (json['background_color'] != null) {
      backgroundColor = Color(json['background_color']);
    }
  }
}
