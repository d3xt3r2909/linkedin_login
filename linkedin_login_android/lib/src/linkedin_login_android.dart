import 'package:linkedin_login_platform_interface/linkedin_login_platform_interface.dart';

/// An implementation of [KlarMobile3dsPlatform] for Android.
class LinkedinLoginAndroid extends LinkedinLoginPlatform {
  LinkedinLoginAndroid() ;

  /// Registers this class as the default instance of [LinkedinLoginAndroid].
  static void registerWith() =>
      LinkedinLoginPlatform.instance = LinkedinLoginAndroid();

  @override
  String displayName() => 'Linkedin Login Android';
}
