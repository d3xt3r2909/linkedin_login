import 'package:linkedin_login_platform_interface/src/linkedin_platform.dart';
import 'package:test/test.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  late TestLinkedInLoginPlatform tested;

  setUp(() => tested = TestLinkedInLoginPlatform());

  test('instance will throw if it is not initialized', () async {
    expect(
      () => LinkedinLoginPlatform.instance,
      throwsA(isA<UnimplementedError>()),
    );
  });

  test('instance could be set', () async {
    LinkedinLoginPlatform.instance = TestLinkedInLoginPlatform();

    expect(LinkedinLoginPlatform.instance, isA<TestLinkedInLoginPlatform>());
  });

  test(
      'getting platform parameter for controller via '
      'platformWebControllerParam is called', () async {
    // Access the getter to increment the count
    final _ = tested.platformWebControllerParam;
    expect(tested.platformWebControllerParamCount, equals(1));
  });
}

class TestLinkedInLoginPlatform extends LinkedinLoginPlatform {
  var platformWebControllerParamCount = 0;

  @override
  PlatformWebViewControllerCreationParams get platformWebControllerParam {
    platformWebControllerParamCount++;
    return PlatformWebViewControllerCreationParams();
  }
}
