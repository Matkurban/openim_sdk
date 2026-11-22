#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  xue_hua_app_badge
  xue_hua_audio
  xue_hua_barcode_scanner
  xue_hua_device_info
  xue_hua_file_operations
  xue_hua_media_compression
  xue_hua_media_info
  xue_hua_navite_accept_sharing
  xue_hua_navite_auto_update
  xue_hua_navite_background_downloader
  xue_hua_navite_cache_manager
  xue_hua_navite_clipboard
  xue_hua_navite_drag_drop
  xue_hua_navite_share
  xue_hua_navite_system_tray
  xue_hua_navite_video_player
  xue_hua_navite_volume_controller
  xue_hua_navite_window_manager
  xue_hua_screen_protection
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
  jni
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/linux plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/linux plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
