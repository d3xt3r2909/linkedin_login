import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of klar_mobile_3ds must implement.
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

  static set instance(LinkedinLoginPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  String displayName() {
    throw UnimplementedError(
      'initialize() has not been implemented',
    );
  }
}
