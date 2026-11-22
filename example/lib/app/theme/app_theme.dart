import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// 全局 Apple 风格全组件自定义主题（严格遵循 `DESIGN-apple.md`）。
///
/// Full custom Apple-inspired light & dark themes built from `DESIGN-apple.md`:
/// - Single interactive accent: Action Blue (`#0066CC`) on light, Sky Link Blue (`#2997FF`) on dark.
/// - Zero decorative gradients & zero UI-chrome shadows (`elevation: 0`), separated by surface shifts and 1px hairlines.
/// - SF Pro typography hierarchy (`17px` body, negative tracking, `300/400/600/700` weight ladder without `500`).
/// - Pill (`9999`) CTAs/chips/inputs, `18px` utility cards & dialogs, `11px` pearl menus, `8px` compact controls.
abstract final class AppTheme {
  static const BorderRadius _radiusSm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius _radiusMd = BorderRadius.all(Radius.circular(11));
  static const BorderRadius _radiusLg = BorderRadius.all(Radius.circular(18));
  static const BorderRadius _radiusPill = BorderRadius.all(
    Radius.circular(9999),
  );

  /// 浅色主题（纯白 Canvas + 羊皮纸 Parchment + Action Blue `#0066CC`）。
  static ThemeData light() {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.bodyOnDark,
      primaryContainer: AppColors.canvasParchment,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.ink,
      onSecondary: AppColors.bodyOnDark,
      secondaryContainer: AppColors.surfacePearl,
      onSecondaryContainer: AppColors.inkMuted80,
      tertiary: AppColors.primaryFocus,
      onTertiary: AppColors.bodyOnDark,
      error: AppColors.danger,
      onError: AppColors.bodyOnDark,
      surface: AppColors.canvas,
      onSurface: AppColors.ink,
      surfaceContainerLowest: AppColors.canvas,
      surfaceContainerLow: AppColors.surfacePearl,
      surfaceContainer: AppColors.canvasParchment,
      surfaceContainerHigh: AppColors.dividerSoft,
      surfaceContainerHighest: AppColors.hairline,
      onSurfaceVariant: AppColors.inkMuted48,
      outline: AppColors.hairline,
      outlineVariant: AppColors.dividerSoft,
      shadow: Colors.transparent,
      scrim: Colors.black54,
      inverseSurface: AppColors.surfaceTile1,
      onInverseSurface: AppColors.bodyOnDark,
      inversePrimary: AppColors.primaryOnDark,
    );

    return _buildTheme(
      scheme: scheme,
      scaffoldBg: AppColors.canvasParchment,
      surfaceBg: AppColors.canvas,
      barBg: AppColors.canvasParchment,
      hairline: AppColors.hairline,
      divider: AppColors.dividerSoft,
      hint: AppColors.inkMuted48,
      textPrimary: AppColors.ink,
      textSecondary: AppColors.inkMuted80,
      linkColor: AppColors.primary,
      isDark: false,
    );
  }

  /// 深色主题（纯黑画布 + Near-Black Tile `#272729`/`#2A2A2C` + Sky Link Blue `#2997FF`）。
  static ThemeData dark() {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryOnDark,
      onPrimary: AppColors.surfaceBlack,
      primaryContainer: AppColors.surfaceTile2,
      onPrimaryContainer: AppColors.primaryOnDark,
      secondary: AppColors.surfaceTile2,
      onSecondary: AppColors.bodyOnDark,
      secondaryContainer: AppColors.surfaceTile3,
      onSecondaryContainer: AppColors.bodyMuted,
      tertiary: AppColors.primaryFocus,
      onTertiary: AppColors.bodyOnDark,
      error: AppColors.danger,
      onError: AppColors.bodyOnDark,
      surface: AppColors.surfaceTile1,
      onSurface: AppColors.bodyOnDark,
      surfaceContainerLowest: AppColors.surfaceBlack,
      surfaceContainerLow: AppColors.surfaceTile3,
      surfaceContainer: AppColors.surfaceTile1,
      surfaceContainerHigh: AppColors.surfaceTile2,
      surfaceContainerHighest: AppColors.hairlineDark,
      onSurfaceVariant: AppColors.bodyMuted,
      outline: AppColors.hairlineDark,
      outlineVariant: AppColors.surfaceTile2,
      shadow: Colors.transparent,
      scrim: Colors.black87,
      inverseSurface: AppColors.canvas,
      onInverseSurface: AppColors.ink,
      inversePrimary: AppColors.primary,
    );

    return _buildTheme(
      scheme: scheme,
      scaffoldBg: AppColors.surfaceBlack,
      surfaceBg: AppColors.surfaceTile1,
      barBg: AppColors.surfaceTile3,
      hairline: AppColors.hairlineDark,
      divider: AppColors.surfaceTile2,
      hint: AppColors.bodyMuted,
      textPrimary: AppColors.bodyOnDark,
      textSecondary: AppColors.bodyMuted,
      linkColor: AppColors.primaryOnDark,
      isDark: true,
    );
  }

  static TextTheme _buildTextTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      // hero-display (56 / 600 / 1.07 / -0.28)
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w600,
        height: 1.07,
        letterSpacing: -0.28,
        color: primaryText,
      ),
      // display-lg (40 / 600 / 1.10 / 0)
      displayMedium: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.10,
        letterSpacing: 0,
        color: primaryText,
      ),
      // display-md (34 / 600 / 1.47 / -0.374)
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        height: 1.47,
        letterSpacing: -0.374,
        color: primaryText,
      ),
      // lead (28 / 400 / 1.14 / 0.196)
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.14,
        letterSpacing: 0.196,
        color: primaryText,
      ),
      // lead-airy (24 / 300 / 1.50 / 0)
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        height: 1.50,
        letterSpacing: 0,
        color: primaryText,
      ),
      // tagline (21 / 600 / 1.19 / 0.231)
      headlineSmall: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        height: 1.19,
        letterSpacing: 0.231,
        color: primaryText,
      ),
      // tagline / section header
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        height: 1.19,
        letterSpacing: 0.231,
        color: primaryText,
      ),
      // body-strong (17 / 600 / 1.24 / -0.374)
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.24,
        letterSpacing: -0.374,
        color: primaryText,
      ),
      // caption-strong (14 / 600 / 1.29 / -0.224)
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: -0.224,
        color: primaryText,
      ),
      // body (17 / 400 / 1.47 / -0.374)
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.47,
        letterSpacing: -0.374,
        color: primaryText,
      ),
      // caption (14 / 400 / 1.43 / -0.224)
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: -0.224,
        color: primaryText,
      ),
      // fine-print (12 / 400 / 1.25 / -0.12)
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.25,
        letterSpacing: -0.12,
        color: secondaryText,
      ),
      // button-utility (14 / 400 / 1.29 / -0.224)
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.29,
        letterSpacing: -0.224,
        color: primaryText,
      ),
      // nav-link (12 / 400 / 1.0 / -0.12)
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.15,
        letterSpacing: -0.12,
        color: secondaryText,
      ),
      // micro-legal (10 / 400 / 1.3 / -0.08)
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.30,
        letterSpacing: -0.08,
        color: secondaryText,
      ),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required Color scaffoldBg,
    required Color surfaceBg,
    required Color barBg,
    required Color hairline,
    required Color divider,
    required Color hint,
    required Color textPrimary,
    required Color textSecondary,
    required Color linkColor,
    required bool isDark,
  }) {
    final TextTheme textTheme = _buildTextTheme(textPrimary, textSecondary);
    final Color ctaFill = AppColors.primary;

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      canvasColor: surfaceBg,
      dividerColor: divider,
      hintColor: hint,
      shadowColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: linkColor.withValues(alpha: 0.08),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: textPrimary, size: 22),

      // 1. Sub-nav Frosted / AppBar (52px height, flat, 1px hairline)
      appBarTheme: AppBarTheme(
        backgroundColor: barBg,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 52,
        titleSpacing: 16,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.374,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary, size: 22),
        actionsIconTheme: IconThemeData(color: linkColor, size: 22),
        shape: Border(bottom: BorderSide(color: hairline, width: 0.8)),
      ),

      // 2. NavigationBar (flat parchment/tile bar, hairline top border, no pill indicator fill)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: barBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 60,
        indicatorColor: linkColor.withValues(alpha: 0.12),
        indicatorShape: const StadiumBorder(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
          Set<WidgetState> states,
        ) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? linkColor : hint, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
          Set<WidgetState> states,
        ) {
          final bool selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            letterSpacing: -0.12,
            color: selected ? linkColor : hint,
          );
        }),
      ),

      // 3. TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: linkColor,
        unselectedLabelColor: hint,
        indicatorColor: linkColor,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: hairline,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.224,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.224,
        ),
      ),

      // 4. Store Utility Card (rounded.lg = 18px, flat, 1px hairline border)
      cardTheme: CardThemeData(
        color: surfaceBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: _radiusLg,
          side: BorderSide(color: hairline, width: 1),
        ),
      ),

      // 5. Dialog (rounded.lg = 18px, flat, 1px hairline)
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: _radiusLg,
          side: BorderSide(color: hairline, width: 1),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
      ),

      // 6. BottomSheet (rounded.lg top corners, flat)
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // 7. Search & Form Inputs (pill / rounded.md, 1px hairline, Focus Blue 2px focus ring)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBg,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        hintStyle: TextStyle(
          color: hint,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.224,
        ),
        labelStyle: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: TextStyle(
          color: linkColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: hint,
        suffixIconColor: hint,
        border: OutlineInputBorder(
          borderRadius: _radiusMd,
          borderSide: BorderSide(color: hairline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _radiusMd,
          borderSide: BorderSide(color: hairline, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: _radiusMd,
          borderSide: BorderSide(color: AppColors.primaryFocus, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: _radiusMd,
          borderSide: BorderSide(color: AppColors.danger, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: _radiusMd,
          borderSide: BorderSide(color: AppColors.danger, width: 2),
        ),
      ),

      // 8. Primary Pill CTA (button-primary: Action Blue #0066CC, pill 9999, 11x22)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ctaFill,
          foregroundColor: AppColors.bodyOnDark,
          disabledBackgroundColor: ctaFill.withValues(alpha: 0.35),
          disabledForegroundColor: AppColors.bodyOnDark.withValues(alpha: 0.7),
          elevation: 0,
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.32,
          ),
        ),
      ),

      // 9. ElevatedButton (mirrors primary pill without shadow)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ctaFill,
          foregroundColor: AppColors.bodyOnDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.32,
          ),
        ),
      ),

      // 10. Secondary Ghost Pill (button-secondary-pill: transparent + 1px primary border + pill)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: linkColor,
          backgroundColor: Colors.transparent,
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          side: BorderSide(color: linkColor, width: 1),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.224,
          ),
        ),
      ),

      // 11. Text Link Button (text-link / text-link-on-dark)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: linkColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.224,
          ),
        ),
      ),

      // 12. Circular IconButton (44x44 touch target)
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(40, 40),
          shape: const CircleBorder(),
        ),
      ),

      // 13. Switch (Apple Action Blue track when selected)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(AppColors.canvas),
        trackColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return states.contains(WidgetState.selected)
              ? ctaFill
              : (isDark
                    ? AppColors.hairlineDark
                    : AppColors.surfaceChipTranslucent);
        }),
        trackOutlineColor: WidgetStateProperty.all<Color>(Colors.transparent),
      ),

      // 14. Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return states.contains(WidgetState.selected)
              ? ctaFill
              : Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all<Color>(AppColors.bodyOnDark),
        side: BorderSide(color: hint, width: 1.4),
        shape: const RoundedRectangleBorder(borderRadius: _radiusSm),
      ),

      // 15. Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return states.contains(WidgetState.selected) ? linkColor : hint;
        }),
      ),

      // 16. Configurator Option Chip (pill, 1px hairline -> 2px Focus Blue when selected)
      chipTheme: ChipThemeData(
        backgroundColor: surfaceBg,
        selectedColor: surfaceBg,
        disabledColor: divider,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.224,
          color: textPrimary,
        ),
        secondaryLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.224,
          color: linkColor,
        ),
        side: BorderSide(color: hairline, width: 1),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        showCheckmark: false,
      ),

      // 17. SegmentedButton (Apple pill segmented control)
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            return states.contains(WidgetState.selected) ? ctaFill : surfaceBg;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            return states.contains(WidgetState.selected)
                ? AppColors.bodyOnDark
                : textPrimary;
          }),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(color: hairline, width: 1),
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(const StadiumBorder()),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.224,
            ),
          ),
        ),
      ),

      // 18. ListTile
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        iconColor: textSecondary,
        titleTextStyle: textTheme.bodyLarge?.copyWith(fontSize: 16),
        subtitleTextStyle: textTheme.bodySmall?.copyWith(color: hint),
        minLeadingWidth: 28,
      ),

      // 19. Divider (hairline)
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 0.8,
        space: 0.8,
      ),

      // 20. PopupMenu (pearl capsule rounded.md = 11px, flat, 1px hairline)
      popupMenuTheme: PopupMenuThemeData(
        color: isDark ? AppColors.surfaceTile2 : AppColors.surfacePearl,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: _radiusMd,
          side: BorderSide(color: hairline, width: 1),
        ),
        textStyle: textTheme.bodyMedium,
      ),

      // 21. SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceTile1,
        contentTextStyle: const TextStyle(
          color: AppColors.bodyOnDark,
          fontSize: 14,
          letterSpacing: -0.224,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: _radiusPill),
      ),

      // 22. FloatingActionButton (flat circular chip)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ctaFill,
        foregroundColor: AppColors.bodyOnDark,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const CircleBorder(),
      ),

      // 23. ProgressIndicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: linkColor,
        linearTrackColor: divider,
        circularTrackColor: divider,
      ),
    );
  }
}
