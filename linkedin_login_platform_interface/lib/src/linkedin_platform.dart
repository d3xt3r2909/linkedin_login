import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// The interface that implementations
/// of linkedin_login platforms must implement.
abstract class LinkedinLoginPlatform extends PlatformInterface {
  LinkedinLoginPlatform() : super(token: _token);

  static final Object _token = Object();

  static LinkedinLoginPlatform? _instance;

  static LinkedinLoginPlatform get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
        'Instance must be initialized before usage.',
      );
    }
    return instance;
  }

  static set instance(final LinkedinLoginPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  PlatformWebViewControllerCreationParams get platformWebControllerParam {
    throw UnimplementedError(
      'platformWebControllerParam() has not been implemented',
    );
  }
}
