import 'package:linkedin_login_platform_interface/linkedin_login_platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// An implementation of [LinkedinLoginPlatform] for Android.
class LinkedinLoginIos extends LinkedinLoginPlatform {
  LinkedinLoginIos();

  /// Registers this class as the default instance of [LinkedinLoginIos].
  static void registerWith() =>
      LinkedinLoginPlatform.instance = LinkedinLoginIos();

  @override
  PlatformWebViewControllerCreationParams get platformWebControllerParam =>
      WebKitWebViewControllerCreationParams();
}
