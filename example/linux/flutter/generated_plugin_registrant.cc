//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <xue_hua_app_badge/xue_hua_app_badge_plugin.h>
#include <xue_hua_audio/xue_hua_audio_linux_plugin.h>
#include <xue_hua_barcode_scanner/xue_hua_barcode_scanner_plugin.h>
#include <xue_hua_device_info/xue_hua_device_info_plugin.h>
#include <xue_hua_file_operations/xue_hua_file_operations_plugin.h>
#include <xue_hua_media_compression/xue_hua_media_compression_linux_plugin.h>
#include <xue_hua_media_info/xue_hua_media_info_linux_plugin.h>
#include <xue_hua_navite_accept_sharing/xue_hua_navite_accept_sharing_plugin.h>
#include <xue_hua_navite_auto_update/xue_hua_navite_auto_update_plugin.h>
#include <xue_hua_navite_background_downloader/xue_hua_navite_background_downloader_plugin.h>
#include <xue_hua_navite_cache_manager/xue_hua_navite_cache_manager_plugin.h>
#include <xue_hua_navite_clipboard/xue_hua_navite_clipboard_plugin.h>
#include <xue_hua_navite_drag_drop/xue_hua_navite_drag_drop_plugin.h>
#include <xue_hua_navite_share/xue_hua_navite_share_plugin.h>
#include <xue_hua_navite_system_tray/xue_hua_navite_system_tray_plugin.h>
#include <xue_hua_navite_video_player/xue_hua_navite_video_player_plugin.h>
#include <xue_hua_navite_volume_controller/xue_hua_navite_volume_controller_plugin.h>
#include <xue_hua_navite_window_manager/xue_hua_navite_window_manager_plugin.h>
#include <xue_hua_screen_protection/xue_hua_screen_protection_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) xue_hua_app_badge_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaAppBadgePlugin");
  xue_hua_app_badge_plugin_register_with_registrar(xue_hua_app_badge_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_audio_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaAudioLinuxPlugin");
  xue_hua_audio_linux_plugin_register_with_registrar(xue_hua_audio_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_barcode_scanner_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaBarcodeScannerPlugin");
  xue_hua_barcode_scanner_plugin_register_with_registrar(xue_hua_barcode_scanner_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_device_info_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaDeviceInfoPlugin");
  xue_hua_device_info_plugin_register_with_registrar(xue_hua_device_info_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_file_operations_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaFileOperationsPlugin");
  xue_hua_file_operations_plugin_register_with_registrar(xue_hua_file_operations_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_media_compression_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaMediaCompressionLinuxPlugin");
  xue_hua_media_compression_linux_plugin_register_with_registrar(xue_hua_media_compression_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_media_info_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaMediaInfoLinuxPlugin");
  xue_hua_media_info_linux_plugin_register_with_registrar(xue_hua_media_info_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_accept_sharing_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteAcceptSharingPlugin");
  xue_hua_navite_accept_sharing_plugin_register_with_registrar(xue_hua_navite_accept_sharing_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_auto_update_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteAutoUpdatePlugin");
  xue_hua_navite_auto_update_plugin_register_with_registrar(xue_hua_navite_auto_update_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_background_downloader_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteBackgroundDownloaderPlugin");
  xue_hua_navite_background_downloader_plugin_register_with_registrar(xue_hua_navite_background_downloader_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_cache_manager_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteCacheManagerPlugin");
  xue_hua_navite_cache_manager_plugin_register_with_registrar(xue_hua_navite_cache_manager_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_clipboard_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteClipboardPlugin");
  xue_hua_navite_clipboard_plugin_register_with_registrar(xue_hua_navite_clipboard_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_drag_drop_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteDragDropPlugin");
  xue_hua_navite_drag_drop_plugin_register_with_registrar(xue_hua_navite_drag_drop_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_share_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteSharePlugin");
  xue_hua_navite_share_plugin_register_with_registrar(xue_hua_navite_share_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_system_tray_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteSystemTrayPlugin");
  xue_hua_navite_system_tray_plugin_register_with_registrar(xue_hua_navite_system_tray_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_video_player_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteVideoPlayerPlugin");
  xue_hua_navite_video_player_plugin_register_with_registrar(xue_hua_navite_video_player_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_volume_controller_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteVolumeControllerPlugin");
  xue_hua_navite_volume_controller_plugin_register_with_registrar(xue_hua_navite_volume_controller_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_navite_window_manager_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaNaviteWindowManagerPlugin");
  xue_hua_navite_window_manager_plugin_register_with_registrar(xue_hua_navite_window_manager_registrar);
  g_autoptr(FlPluginRegistrar) xue_hua_screen_protection_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XueHuaScreenProtectionPlugin");
  xue_hua_screen_protection_plugin_register_with_registrar(xue_hua_screen_protection_registrar);
}
