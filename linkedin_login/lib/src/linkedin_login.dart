import 'package:linkedin_login_platform_interface/linkedin_login_platform_interface.dart';

class LinkedinLogin {
  static LinkedinLoginPlatform get _platform => LinkedinLoginPlatform.instance;

  String displayName() => _platform.displayName();
}
