import 'package:flutter/material.dart';

/// Class will generate standard flutter button, but with properties you can
/// modify look of the button
/// Also, you don't need to use this widget, you can use standard button widget
class LinkedInButtonStandardWidget extends StatelessWidget {
  final Function onTap;
  final double iconHeight, iconWeight;
  final String iconAssetPath;
  final String buttonText;
  final Color buttonColor;
  final EdgeInsets textPadding;

  LinkedInButtonStandardWidget({
    @required this.onTap,
    this.iconHeight = 30.0,
    this.iconWeight = 30.0,
    this.iconAssetPath = 'assets/linked_in_logo.png',
    this.buttonText = 'Sign in with LinkedIn',
    this.buttonColor = Colors.white,
    this.textPadding = const EdgeInsets.all(4.0),
  });

  @override
  Widget build(BuildContext context) => Material(
        child: InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  iconAssetPath,
                  package: 'linkedin_login',
                  width: iconWeight,
                  height: iconHeight,
                ),
                Container(
                  padding: textPadding,
                  color: Colors.blue,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
