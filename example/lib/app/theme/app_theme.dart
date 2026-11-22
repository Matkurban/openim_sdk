import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// 应用全组件自定义主题配置（浅色 / 深色双套，覆盖所有核心组件样式）。
///
/// Full custom component theme configuration for light and dark modes.
abstract final class AppTheme {
  /// 构建浅色主题。
  static ThemeData light() {
    final ColorScheme scheme = const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD9F7E6),
      onPrimaryContainer: Color(0xFF054B24),
      secondary: AppColors.linkBlue,
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: Color(0xFF191919),
      surfaceContainerHighest: Color(0xFFE5E5E5),
      error: AppColors.danger,
      onError: Colors.white,
      outline: Color(0xFFD9D9D9),
    );
    return _buildTheme(
      scheme: scheme,
      scaffoldBg: AppColors.lightBackground,
      appBarBg: AppColors.lightBackground,
      dividerColor: const Color(0xFFE5E5E5),
      inputFill: Colors.white,
      cardColor: AppColors.lightSurface,
      hintColor: const Color(0xFF888888),
    );
  }

  /// 构建深色主题。
  static ThemeData dark() {
    final ColorScheme scheme = const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF163D28),
      onPrimaryContainer: Color(0xFFB7F0CF),
      secondary: Color(0xFF7D90A9),
      onSecondary: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: Color(0xFFE5E5E5),
      surfaceContainerHighest: Color(0xFF2C2C2E),
      error: AppColors.danger,
      onError: Colors.white,
      outline: Color(0xFF3A3A3C),
    );
    return _buildTheme(
      scheme: scheme,
      scaffoldBg: AppColors.darkBackground,
      appBarBg: AppColors.darkSurface,
      dividerColor: const Color(0xFF2C2C2E),
      inputFill: const Color(0xFF262628),
      cardColor: AppColors.darkSurface,
      hintColor: const Color(0xFF8E8E93),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required Color scaffoldBg,
    required Color appBarBg,
    required Color dividerColor,
    required Color inputFill,
    required Color cardColor,
    required Color hintColor,
  }) {
    final BorderRadius radius8 = BorderRadius.circular(8);
    final BorderRadius radius10 = BorderRadius.circular(10);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      dividerColor: dividerColor,
      hintColor: hintColor,
      splashFactory: NoSplash.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBg,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 0,
        height: 60,
        indicatorColor: AppColors.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
          Set<WidgetState> states,
        ) {
          final bool selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.primary : hintColor,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
          Set<WidgetState> states,
        ) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? AppColors.primary : hintColor,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: radius8),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(borderRadius: radius8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.linkBlue,
          shape: RoundedRectangleBorder(borderRadius: radius8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurface,
          shape: RoundedRectangleBorder(borderRadius: radius8),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(Colors.white),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : scheme.outline,
        ),
        trackOutlineColor: WidgetStateProperty.all<Color>(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : hintColor,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: AppColors.primary.withValues(alpha: 0.16),
        side: BorderSide(color: dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: TextStyle(fontSize: 13, color: scheme.onSurface),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: radius8),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? AppColors.primary
                : scheme.surface,
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? Colors.white
                : scheme.onSurface,
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(color: dividerColor),
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: hintColor,
        indicatorColor: AppColors.primary,
        dividerColor: dividerColor,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        iconColor: scheme.onSurface.withValues(alpha: 0.78),
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: scheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(fontSize: 12, color: hintColor),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radius10,
          side: BorderSide(color: dividerColor, width: 0.6),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: radius10),
      ),
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 0.6),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        hintStyle: TextStyle(color: hintColor, fontSize: 14),
        labelStyle: TextStyle(color: hintColor, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: radius8,
          borderSide: BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius8,
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius8,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2E2E30),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radius8),
      ),
    );
  }
}
