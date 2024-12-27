import 'package:linkedin_login_platform_interface/linkedin_login_platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

/// An implementation of [LinkedinLoginPlatform] for Android.
class LinkedinLoginAndroid extends LinkedinLoginPlatform {
  LinkedinLoginAndroid();

  /// Registers this class as the default instance of [LinkedinLoginAndroid].
  static void registerWith() =>
      LinkedinLoginPlatform.instance = LinkedinLoginAndroid();

  @override
  PlatformWebViewControllerCreationParams get platformWebControllerParam =>
      AndroidWebViewControllerCreationParams();
}
