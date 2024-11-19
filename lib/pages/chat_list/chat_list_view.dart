import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/navi_rail_item.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import '../../widgets/matrix.dart';
import 'chat_list_body.dart';
import '../../utils/image_fallback.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final cacheBustParam = AppConfig.version;

    return StreamBuilder<Object?>(
      stream: Matrix.of(context).onShareContentChanged.stream,
      builder: (_, __) {
        final selectMode = controller.selectMode;
        return PopScope(
          canPop: controller.selectMode == SelectMode.normal &&
              !controller.isSearchMode &&
              controller.activeSpaceId == null,
          onPopInvokedWithResult: (pop, _) {
            if (pop) return;
            if (controller.activeSpaceId != null) {
              controller.clearActiveSpace();
              return;
            }
            final selMode = controller.selectMode;
            if (controller.isSearchMode) {
              controller.cancelSearch();
              return;
            }
            if (selMode != SelectMode.normal) {
              controller.cancelAction();
              return;
            }
          },
          child: Column(
            children: [
              // Logo at the top
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width, // Adjust width as needed
                  maxHeight: 73, // Adjust height as needed
                ),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (AppConfig.logoType == "png")
                      Image.network(
                        'assets/assets/banner_transparent.png?cache_bust=$cacheBustParam',
                        fit: BoxFit.contain, // Ensures the image fits within the container
                        height: 60, // Adjust height as needed
                      )
                    else
                      SvgPicture.network(
                        'assets/assets/banner_transparent.svg?cache_bust=$cacheBustParam',
                        fit: BoxFit.contain, // Ensures the image fits within the container
                        height: 60, // Adjust height as needed
                      ),
                  ],
                ),
              ),
              // Main Row Content
              Expanded(
                child: Row(
                  children: [
                    if (FluffyThemes.isColumnMode(context) &&
                        controller.widget.displayNavigationRail) ...[
                      StreamBuilder(
                        key: ValueKey(client.userID.toString()),
                        stream: client.onSync.stream
                            .where((s) => s.hasRoomUpdate)
                            .rateLimit(const Duration(seconds: 1)),
                        builder: (context, _) {
                          final allSpaces = Matrix.of(context)
                              .client
                              .rooms
                              .where((room) => room.isSpace);
                          final rootSpaces = allSpaces
                              .where(
                                (space) => !allSpaces.any(
                                  (parentSpace) => parentSpace.spaceChildren
                                      .any((child) => child.roomId == space.id),
                                ),
                              )
                              .toList();

                          return SizedBox(
                            width: FluffyThemes.navRailWidth,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: rootSpaces.length + 2,
                              itemBuilder: (context, i) {
                                if (i == 0) {
                                  return NaviRailItem(
                                    isSelected:
                                        controller.activeSpaceId == null,
                                    onTap: controller.clearActiveSpace,
                                    icon: const Icon(Icons.forum_outlined),
                                    selectedIcon: const Icon(Icons.forum),
                                    toolTip: L10n.of(context).chats,
                                    unreadBadgeFilter: (room) => true,
                                  );
                                }
                                i--;
                                if (i == rootSpaces.length) {
                                  return NaviRailItem(
                                    isSelected: false,
                                    onTap: () => context.go('/rooms/newspace'),
                                    icon: const Icon(Icons.add),
                                    toolTip: L10n.of(context).createNewSpace,
                                  );
                                }
                                final space = rootSpaces[i];
                                final displayname =
                                    rootSpaces[i].getLocalizedDisplayname(
                                  MatrixLocals(L10n.of(context)),
                                );
                                final spaceChildrenIds = space.spaceChildren
                                    .map((c) => c.roomId)
                                    .toSet();
                                return NaviRailItem(
                                  toolTip: displayname,
                                  isSelected:
                                      controller.activeSpaceId == space.id,
                                  onTap: () => controller
                                      .setActiveSpace(rootSpaces[i].id),
                                  unreadBadgeFilter: (room) =>
                                      spaceChildrenIds.contains(room.id),
                                  icon: Avatar(
                                    mxContent: rootSpaces[i].avatar,
                                    name: displayname,
                                    size: 32,
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 4,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Container(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ],
                    Expanded(
                      child: GestureDetector(
                        onTap: FocusManager.instance.primaryFocus?.unfocus,
                        excludeFromSemantics: true,
                        behavior: HitTestBehavior.translucent,
                        child: Scaffold(
                          body: ChatListViewBody(controller),
                          floatingActionButton: selectMode == SelectMode.normal &&
                            !controller.isSearchMode &&
                            controller.activeSpaceId == null
                        ? FloatingActionButton.extended(
                            onPressed: () =>
                                context.go('/rooms/newprivatechat'),
                            icon: const Icon(Icons.add_outlined),
                            label: Text(
                              L10n.of(context).chat,
                              overflow: TextOverflow.fade,
                            ),
                          )
                        : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
