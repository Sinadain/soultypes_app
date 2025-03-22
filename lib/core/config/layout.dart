import 'package:flutter/material.dart';

class AppLayout {
  // Constants
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 24.0;
  static const double defaultRadius = 12.0;
  static const double defaultIconSize = 24.0;
  static const double defaultButtonHeight = 48.0;

  // Common Colors
  static Color primaryColor = Colors.deepPurple;
  static Color secondaryColor = Colors.deepPurple.shade50;
  static Color textColor = Colors.black87;
  static Color textColorLight = Colors.grey[600]!;
  static Color borderColor = Colors.grey.shade300;

  // Common Text Styles
  static TextStyle titleStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontWeight: FontWeight.bold,
      color: primaryColor,
    );
  }

  static TextStyle subtitleStyle(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.titleMedium!.copyWith(color: textColorLight);
  }

  static TextStyle bodyStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: textColor);
  }

  // Common Padding
  static EdgeInsets defaultPaddingAll = const EdgeInsets.all(defaultPadding);
  static EdgeInsets defaultPaddingHorizontal = const EdgeInsets.symmetric(
    horizontal: defaultPadding,
  );
  static EdgeInsets defaultPaddingVertical = const EdgeInsets.symmetric(
    vertical: defaultPadding,
  );
  static EdgeInsets defaultPaddingTop = const EdgeInsets.only(
    top: defaultPadding,
  );
  static EdgeInsets defaultPaddingBottom = const EdgeInsets.only(
    bottom: defaultPadding,
  );
  static EdgeInsets defaultPaddingLeft = const EdgeInsets.only(
    left: defaultPadding,
  );
  static EdgeInsets defaultPaddingRight = const EdgeInsets.only(
    right: defaultPadding,
  );

  // Common Spacing
  static Widget defaultSpacingVertical(BuildContext context) =>
      const SizedBox(height: defaultSpacing);
  static Widget defaultSpacingHorizontal(BuildContext context) =>
      const SizedBox(width: defaultSpacing);
  static Widget smallSpacingVertical(BuildContext context) =>
      const SizedBox(height: defaultPadding);
  static Widget smallSpacingHorizontal(BuildContext context) =>
      const SizedBox(width: defaultPadding);

  // Common Containers
  static Widget pageContainer({
    required BuildContext context,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: child,
    );
  }

  static Widget sectionContainer({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding ?? defaultPaddingAll,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Common Buttons
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: defaultButtonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
    );
  }

  static ButtonStyle secondaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(vertical: defaultButtonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        side: BorderSide(color: primaryColor),
      ),
    );
  }

  // Common Cards
  static Widget card({
    required BuildContext context,
    required Widget child,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultRadius),
        side: BorderSide(
          color: isSelected ? primaryColor : borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(defaultRadius),
        child: child,
      ),
    );
  }

  // Common Icons
  static Widget iconContainer({
    required IconData icon,
    Color? color,
    double? size,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (color ?? primaryColor).withValues(alpha: 26),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color ?? primaryColor,
        size: size ?? defaultIconSize,
      ),
    );
  }

  // Common Text
  static Widget sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: defaultPaddingBottom,
      child: Text(title, style: titleStyle(context)),
    );
  }

  static Widget sectionSubtitle(BuildContext context, String subtitle) {
    return Padding(
      padding: defaultPaddingBottom,
      child: Text(subtitle, style: subtitleStyle(context)),
    );
  }

  // Common Layout Helpers
  static Widget padded({required Widget child}) {
    return Padding(padding: defaultPaddingAll, child: child);
  }

  static Widget centered({required Widget child}) {
    return Center(child: child);
  }

  static Widget expanded({required Widget child}) {
    return Expanded(child: child);
  }

  static Widget safeArea({required Widget child}) {
    return SafeArea(child: child);
  }

  // Common Dividers
  static Widget divider(BuildContext context) {
    return Divider(color: borderColor, thickness: 1, height: defaultSpacing);
  }

  static Widget verticalDivider(BuildContext context) {
    return VerticalDivider(
      color: borderColor,
      thickness: 1,
      width: defaultSpacing,
    );
  }
}
