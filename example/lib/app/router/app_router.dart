import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../core/events/im_social_event.dart';
import '../../features/auth/appeal_page.dart';
import '../../features/auth/forgot_password_page.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/qr_desktop_login_confirm_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/call/call_overlay_page.dart';
import '../../features/chat/chat_media_gallery_page.dart';
import '../../features/chat/chat_page.dart';
import '../../features/chat/chat_search_page.dart';
import '../../features/chat/location_picker_page.dart';
import '../../features/chat/merge_message_detail_page.dart';
import '../../features/chat/private_chat_detail_page.dart';
import '../../features/contact/add_contact_page.dart';
import '../../features/contact/blacklist_page.dart';
import '../../features/contact/contact_page.dart';
import '../../features/contact/contact_profile_page.dart';
import '../../features/contact/friend_remark_page.dart';
import '../../features/contact/new_friends_page.dart';
import '../../features/conversation/conversation_page.dart';
import '../../features/conversation/global_search_page.dart';
import '../../features/favorite/favorite_detail_page.dart';
import '../../features/favorite/favorite_note_editor_page.dart';
import '../../features/favorite/favorites_page.dart';
import '../../features/group/create_group_page.dart';
import '../../features/group/group_admins_page.dart';
import '../../features/group/group_announcement_page.dart';
import '../../features/group/group_chat_detail_page.dart';
import '../../features/group/group_management_page.dart';
import '../../features/group/group_member_detail_page.dart';
import '../../features/group/group_members_page.dart';
import '../../features/group/group_notifications_page.dart';
import '../../features/group/group_qr_code_page.dart';
import '../../features/group/group_transfer_owner_page.dart';
import '../../features/group/join_group_page.dart';
import '../../features/group/my_groups_page.dart';
import '../../features/main_shell/main_shell_scaffold.dart';
import '../../features/moments/moment_detail_page.dart';
import '../../features/moments/moment_notifications_page.dart';
import '../../features/moments/moment_publish_page.dart';
import '../../features/moments/moments_page.dart';
import '../../features/moments/user_moments_page.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/points/points_page.dart';
import '../../features/points/points_transactions_page.dart';
import '../../features/points/red_packet_detail_page.dart';
import '../../features/points/send_red_packet_page.dart';
import '../../features/preview/file_preview_page.dart';
import '../../features/preview/image_preview_page.dart';
import '../../features/preview/location_preview_page.dart';
import '../../features/preview/video_preview_page.dart';
import '../../features/profile/account_security_page.dart';
import '../../features/profile/device_info_page.dart';
import '../../features/profile/download_manager_page.dart';
import '../../features/profile/edit_profile_page.dart';
import '../../features/profile/my_qr_code_page.dart';
import '../../features/profile/payment_password_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/profile/settings_page.dart';
import '../../features/report/report_page.dart';
import '../../features/scanner/scanner_page.dart';
import '../../features/splash/splash_page.dart';
import '../../shared/widgets/empty_state_view.dart';
import 'app_routes.dart';

/// 全局声明式自适应路由工厂（基于 `xue_hua_adaptive_sliding_layout`）。
///
/// Global declarative `AdaptiveRouter` factory covering all 48 app pages.
abstract final class AppRouter {
  /// 创建应用全局唯一 [AdaptiveRouter] 实例。
  static AdaptiveRouter create() {
    return AdaptiveRouter(
      initialLocation: AppRoutes.splash,
      routes: <AdaptiveRouteBase>[
        AdaptiveRoute(
          path: AppRoutes.splash,
          builder: (BuildContext _, AdaptiveRouteState _) => const SplashPage(),
        ),
        AdaptiveRoute(
          path: AppRoutes.onboarding,
          builder: (BuildContext _, AdaptiveRouteState _) =>
              const OnboardingPage(),
        ),
        AdaptiveRoute(
          path: AppRoutes.login,
          builder: (BuildContext _, AdaptiveRouteState _) => const LoginPage(),
        ),
        AdaptiveRoute(
          path: AppRoutes.register,
          builder: (BuildContext _, AdaptiveRouteState _) =>
              const RegisterPage(),
        ),
        AdaptiveRoute(
          path: AppRoutes.forgotPassword,
          builder: (BuildContext _, AdaptiveRouteState _) =>
              const ForgotPasswordPage(),
        ),
        AdaptiveRoute(
          path: AppRoutes.appeal,
          builder: (BuildContext _, AdaptiveRouteState _) => const AppealPage(),
        ),
        AdaptiveRoute(
          path: AppRoutes.scanner,
          fullscreenDialog: true,
          builder: (BuildContext _, AdaptiveRouteState _) =>
              const ScannerPage(),
        ),
        AdaptiveRoute(
          path: AppRoutes.qrDesktopLoginConfirm,
          fullscreenDialog: true,
          builder: (BuildContext _, AdaptiveRouteState state) =>
              QrDesktopLoginConfirmPage(
                sessionId: (state.arguments as String?) ?? '',
              ),
        ),
        AdaptiveRoute(
          path: AppRoutes.call,
          fullscreenDialog: true,
          builder: (BuildContext _, AdaptiveRouteState state) =>
              CallOverlayPage(session: state.arguments as CallSession?),
        ),
        AdaptiveRoute(
          path: AppRoutes.imagePreview,
          fullscreenDialog: true,
          builder: (BuildContext _, AdaptiveRouteState state) {
            final Map<String, Object>? args =
                state.arguments as Map<String, Object>?;
            final List<String> urls =
                (args?['urls'] as List<String>?) ?? const <String>[];
            final int index = (args?['index'] as int?) ?? 0;
            return ImagePreviewPage(imageUrls: urls, initialIndex: index);
          },
        ),
        AdaptiveRoute(
          path: AppRoutes.videoPreview,
          fullscreenDialog: true,
          builder: (BuildContext _, AdaptiveRouteState state) {
            final Map<String, String?>? args =
                state.arguments as Map<String, String?>?;
            return VideoPreviewPage(
              videoUrl: args?['url'] ?? '',
              title: args?['title'],
            );
          },
        ),
        AdaptiveRoute(
          path: AppRoutes.filePreview,
          builder: (BuildContext _, AdaptiveRouteState state) {
            final Map<String, Object?>? args =
                state.arguments as Map<String, Object?>?;
            return FilePreviewPage(
              fileName: (args?['fileName'] as String?) ?? '文件',
              fileUrl: (args?['fileUrl'] as String?) ?? '',
              fileSize: (args?['fileSize'] as int?) ?? 0,
              localPath: args?['localPath'] as String?,
            );
          },
        ),
        AdaptiveRoute(
          path: AppRoutes.locationPreview,
          builder: (BuildContext _, AdaptiveRouteState state) {
            final Map<String, Object>? args =
                state.arguments as Map<String, Object>?;
            return LocationPreviewPage(
              description: (args?['description'] as String?) ?? '',
              latitude: (args?['latitude'] as double?) ?? 0,
              longitude: (args?['longitude'] as double?) ?? 0,
            );
          },
        ),
        AdaptiveRoute(
          path: AppRoutes.locationPicker,
          builder: (BuildContext _, AdaptiveRouteState _) =>
              const LocationPickerPage(),
        ),
        AdaptiveRoute(
          path: AppRoutes.report,
          builder: (BuildContext _, AdaptiveRouteState state) {
            final Map<String, String>? args =
                state.arguments as Map<String, String>?;
            return ReportPage(
              targetType: args?['type'] ?? 'user',
              targetId: args?['targetId'] ?? '',
            );
          },
        ),
        AdaptiveShellRoute(
          showBreadcrumbs: false,
          initialLeftPaneFraction: 0.36,
          minLeftPaneFraction: 0.28,
          minRightPaneFraction: 0.45,
          placeholder: (BuildContext _) => const EmptyStateView(
            title: 'OpenIM 跨平台聊天',
            subtitle: '在左侧选择会话、联系人或功能项开始使用',
          ),
          builder: (BuildContext _, AdaptiveShellState shell, Widget child) {
            return MainShellScaffold(shell: shell, child: child);
          },
          branches: <AdaptiveBranch>[
            // Branch 0: 会话
            AdaptiveBranch(
              routes: <AdaptiveRoute>[
                AdaptiveRoute(
                  path: AppRoutes.conversations,
                  builder: (BuildContext _, AdaptiveRouteState _) =>
                      const ConversationPage(),
                  routes: <AdaptiveRoute>[
                    AdaptiveRoute(
                      path: 'search',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const GlobalSearchPage(),
                    ),
                    AdaptiveRoute(
                      path: 'add-contact',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const AddContactPage(),
                    ),
                    AdaptiveRoute(
                      path: 'create-group',
                      builder: (BuildContext _, AdaptiveRouteState state) {
                        final List<String> initial =
                            (state.arguments as List<String>?) ??
                            const <String>[];
                        return CreateGroupPage(initialMemberIDs: initial);
                      },
                    ),
                    AdaptiveRoute(
                      path: 'join-group',
                      builder: (BuildContext _, AdaptiveRouteState state) =>
                          JoinGroupPage(
                            initialGroupId: state.arguments as String?,
                          ),
                    ),
                    AdaptiveRoute(
                      path: 'chat/:conversationId',
                      builder: (BuildContext _, AdaptiveRouteState state) {
                        final String cid = Uri.decodeComponent(
                          state.pathParameters['conversationId'] ?? '',
                        );
                        return ChatPage(
                          conversationId: cid,
                          initialConversation:
                              state.arguments as ConversationInfo?,
                        );
                      },
                      routes: <AdaptiveRoute>[
                        AdaptiveRoute(
                          path: 'private-detail',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              PrivateChatDetailPage(
                                conversationId: Uri.decodeComponent(
                                  state.pathParameters['conversationId'] ?? '',
                                ),
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'group-detail',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              GroupChatDetailPage(
                                conversationId: Uri.decodeComponent(
                                  state.pathParameters['conversationId'] ?? '',
                                ),
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'group-management',
                          builder: (BuildContext _, AdaptiveRouteState state) {
                            final Map<String, Object?>? args =
                                state.arguments as Map<String, Object?>?;
                            return GroupManagementPage(
                              conversationId: Uri.decodeComponent(
                                state.pathParameters['conversationId'] ?? '',
                              ),
                              initialGroup: args?['group'] as GroupInfo?,
                              isOwner: (args?['isOwner'] as bool?) ?? false,
                            );
                          },
                        ),
                        AdaptiveRoute(
                          path: 'group-admins',
                          builder: (BuildContext _, AdaptiveRouteState state) {
                            final Map<String, Object?>? args =
                                state.arguments as Map<String, Object?>?;
                            return GroupAdminsPage(
                              group: args?['group'] as GroupInfo?,
                              isOwner: (args?['isOwner'] as bool?) ?? false,
                            );
                          },
                        ),
                        AdaptiveRoute(
                          path: 'group-transfer',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              GroupTransferOwnerPage(
                                group: state.arguments as GroupInfo?,
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'group-members',
                          builder: (BuildContext _, AdaptiveRouteState state) {
                            final Map<String, Object?>? args =
                                state.arguments as Map<String, Object?>?;
                            return GroupMembersPage(
                              conversationId: Uri.decodeComponent(
                                state.pathParameters['conversationId'] ?? '',
                              ),
                              group: args?['group'] as GroupInfo?,
                              selfMember:
                                  args?['selfMember'] as GroupMembersInfo?,
                            );
                          },
                        ),
                        AdaptiveRoute(
                          path: 'group-member/:userId',
                          builder: (BuildContext _, AdaptiveRouteState state) {
                            final Map<String, Object?>? args =
                                state.arguments as Map<String, Object?>?;
                            return GroupMemberDetailPage(
                              userId: Uri.decodeComponent(
                                state.pathParameters['userId'] ?? '',
                              ),
                              group: args?['group'] as GroupInfo?,
                              member: args?['member'] as GroupMembersInfo?,
                              selfMember:
                                  args?['selfMember'] as GroupMembersInfo?,
                            );
                          },
                        ),
                        AdaptiveRoute(
                          path: 'group-announcement',
                          builder: (BuildContext _, AdaptiveRouteState state) {
                            final Map<String, Object?>? args =
                                state.arguments as Map<String, Object?>?;
                            return GroupAnnouncementPage(
                              group: args?['group'] as GroupInfo?,
                              canEdit: (args?['canEdit'] as bool?) ?? false,
                            );
                          },
                        ),
                        AdaptiveRoute(
                          path: 'group-qr',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              GroupQrCodePage(
                                group: state.arguments as GroupInfo?,
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'search',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              ChatSearchPage(
                                conversationId: Uri.decodeComponent(
                                  state.pathParameters['conversationId'] ?? '',
                                ),
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'gallery',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              ChatMediaGalleryPage(
                                conversationId: Uri.decodeComponent(
                                  state.pathParameters['conversationId'] ?? '',
                                ),
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'merge',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              MergeMessageDetailPage(
                                mergeElem: state.arguments as MergeElem?,
                                conversationId: Uri.decodeComponent(
                                  state.pathParameters['conversationId'] ?? '',
                                ),
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'send-red-packet',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              SendRedPacketPage(
                                conversation:
                                    state.arguments as ConversationInfo?,
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'red-packet/:packetId',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              RedPacketDetailPage(
                                packetId: Uri.decodeComponent(
                                  state.pathParameters['packetId'] ?? '',
                                ),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Branch 1: 通讯录
            AdaptiveBranch(
              routes: <AdaptiveRoute>[
                AdaptiveRoute(
                  path: AppRoutes.contacts,
                  builder: (BuildContext _, AdaptiveRouteState _) =>
                      const ContactPage(),
                  routes: <AdaptiveRoute>[
                    AdaptiveRoute(
                      path: 'add-contact',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const AddContactPage(),
                    ),
                    AdaptiveRoute(
                      path: 'new-friends',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const NewFriendsPage(),
                    ),
                    AdaptiveRoute(
                      path: 'group-notifications',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const GroupNotificationsPage(),
                    ),
                    AdaptiveRoute(
                      path: 'my-groups',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const MyGroupsPage(),
                    ),
                    AdaptiveRoute(
                      path: 'profile/:userId',
                      builder: (BuildContext _, AdaptiveRouteState state) =>
                          ContactProfilePage(
                            userId: Uri.decodeComponent(
                              state.pathParameters['userId'] ?? '',
                            ),
                          ),
                      routes: <AdaptiveRoute>[
                        AdaptiveRoute(
                          path: 'remark',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              FriendRemarkPage(
                                userId: Uri.decodeComponent(
                                  state.pathParameters['userId'] ?? '',
                                ),
                                initialFriend: state.arguments as FriendInfo?,
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'moments',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              UserMomentsPage(
                                userId: Uri.decodeComponent(
                                  state.pathParameters['userId'] ?? '',
                                ),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Branch 2: 朋友圈
            AdaptiveBranch(
              routes: <AdaptiveRoute>[
                AdaptiveRoute(
                  path: AppRoutes.moments,
                  builder: (BuildContext _, AdaptiveRouteState _) =>
                      const MomentsPage(),
                  routes: <AdaptiveRoute>[
                    AdaptiveRoute(
                      path: 'publish',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const MomentPublishPage(),
                    ),
                    AdaptiveRoute(
                      path: 'notifications',
                      builder: (BuildContext _, AdaptiveRouteState state) =>
                          MomentNotificationsPage(
                            events:
                                (state.arguments as List<ImSocialEvent>?) ??
                                const <ImSocialEvent>[],
                          ),
                    ),
                    AdaptiveRoute(
                      path: 'user/:userId',
                      builder: (BuildContext _, AdaptiveRouteState state) =>
                          UserMomentsPage(
                            userId: Uri.decodeComponent(
                              state.pathParameters['userId'] ?? '',
                            ),
                          ),
                    ),
                    AdaptiveRoute(
                      path: 'detail/:momentId',
                      builder: (BuildContext _, AdaptiveRouteState state) =>
                          MomentDetailPage(
                            momentId: Uri.decodeComponent(
                              state.pathParameters['momentId'] ?? '',
                            ),
                            initialMoment: state.arguments as MomentInfo?,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            // Branch 3: 我的
            AdaptiveBranch(
              routes: <AdaptiveRoute>[
                AdaptiveRoute(
                  path: AppRoutes.profile,
                  builder: (BuildContext _, AdaptiveRouteState _) =>
                      const ProfilePage(),
                  routes: <AdaptiveRoute>[
                    AdaptiveRoute(
                      path: 'edit',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const EditProfilePage(),
                    ),
                    AdaptiveRoute(
                      path: 'qr',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const MyQrCodePage(),
                    ),
                    AdaptiveRoute(
                      path: 'moments',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          UserMomentsPage(userId: OpenIM.iMManager.userID),
                    ),
                    AdaptiveRoute(
                      path: 'favorites',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const FavoritesPage(),
                      routes: <AdaptiveRoute>[
                        AdaptiveRoute(
                          path: 'detail',
                          builder: (BuildContext _, AdaptiveRouteState state) =>
                              FavoriteDetailPage(
                                item: state.arguments as FavoriteItem?,
                              ),
                        ),
                        AdaptiveRoute(
                          path: 'note-editor',
                          builder: (BuildContext _, AdaptiveRouteState _) =>
                              const FavoriteNoteEditorPage(),
                        ),
                      ],
                    ),
                    AdaptiveRoute(
                      path: 'points',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const PointsPage(),
                      routes: <AdaptiveRoute>[
                        AdaptiveRoute(
                          path: 'transactions',
                          builder: (BuildContext _, AdaptiveRouteState _) =>
                              const PointsTransactionsPage(),
                        ),
                      ],
                    ),
                    AdaptiveRoute(
                      path: 'settings',
                      builder: (BuildContext _, AdaptiveRouteState _) =>
                          const SettingsPage(),
                      routes: <AdaptiveRoute>[
                        AdaptiveRoute(
                          path: 'security',
                          builder: (BuildContext _, AdaptiveRouteState _) =>
                              const AccountSecurityPage(),
                        ),
                        AdaptiveRoute(
                          path: 'payment-password',
                          builder: (BuildContext _, AdaptiveRouteState _) =>
                              const PaymentPasswordPage(),
                        ),
                        AdaptiveRoute(
                          path: 'blacklist',
                          builder: (BuildContext _, AdaptiveRouteState _) =>
                              const BlacklistPage(),
                        ),
                        AdaptiveRoute(
                          path: 'downloads',
                          builder: (BuildContext _, AdaptiveRouteState _) =>
                              const DownloadManagerPage(),
                        ),
                        AdaptiveRoute(
                          path: 'device-info',
                          builder: (BuildContext _, AdaptiveRouteState _) =>
                              const DeviceInfoPage(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
