import 'package:flutter/material.dart';

/// Class will generate standard flutter button, but with properties you can
/// modify look of the button
/// Also, you don't need to use this widget, you can use standard button widget
@immutable
class LinkedInButtonStandardWidget extends StatelessWidget {
  /// Create button with some default values, which you can of course change
  /// whenever you want
  const LinkedInButtonStandardWidget({
    required this.onTap,
    this.iconHeight = 30,
    this.iconWeight = 30,
    this.buttonText = '',
    this.textStyle,
    this.textPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.iconPath,
    this.backgroundColor,
  });

  final Function onTap;
  final double iconHeight, iconWeight;
  final String buttonText;
  final EdgeInsets textPadding;
  final TextStyle? textStyle;
  final String? iconPath;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Material(
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  iconPath ?? 'assets/linked_in_logo.png',
                  package: iconPath == null ? 'linkedin_login' : null,
                  width: iconWeight,
                  height: iconHeight,
                ),
                if (buttonText.isNotEmpty)
                  Container(
                    padding: textPadding,
                    child: Text(
                      buttonText,
                      style: textStyle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
