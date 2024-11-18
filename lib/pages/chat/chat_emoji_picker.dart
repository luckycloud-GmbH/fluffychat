import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'chat.dart';

class ChatEmojiPicker extends StatelessWidget {
  final ChatController controller;
  const ChatEmojiPicker(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      height: controller.showEmojiPicker
          ? MediaQuery.of(context).size.height / 2
          : 0,
      child: controller.showEmojiPicker
          ? EmojiPicker(
              onEmojiSelected: controller.onEmojiSelected,
              onBackspacePressed: controller.emojiPickerBackspace,
              config: Config(
                emojiViewConfig: EmojiViewConfig(
                  columns: 8,
                  noRecents: const NoRecent(),
                  backgroundColor: theme.colorScheme.onInverseSurface,
                ),
                bottomActionBarConfig: const BottomActionBarConfig(
                  enabled: false,
                ),
                categoryViewConfig: CategoryViewConfig(
                  backspaceColor: theme.colorScheme.primary,
                  iconColor: theme.colorScheme.primary.withOpacity(0.5),
                  iconColorSelected: theme.colorScheme.primary,
                  indicatorColor: theme.colorScheme.primary,
                ),
                skinToneConfig: SkinToneConfig(
                  dialogBackgroundColor: Color.lerp(
                    theme.colorScheme.surface,
                    theme.colorScheme.primaryContainer,
                    0.75,
                  )!,
                  indicatorColor: theme.colorScheme.onSurface,
                ),
              ),
            )
          : null,
    );
  }
}

class NoRecent extends StatelessWidget {
  const NoRecent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      L10n.of(context).emoteKeyboardNoRecents,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
