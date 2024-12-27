import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login_android/src/linkedin_login_android.dart';
import 'package:linkedin_login_platform_interface/linkedin_login_platform_interface.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() {
  late LinkedinLoginPlatform tested;

  setUp(() => tested = LinkedinLoginAndroid());

  test(
      'will return $AndroidWebViewControllerCreationParams '
      'when calling getter for param', () async {
    expect(
      tested.platformWebControllerParam,
      isA<AndroidWebViewControllerCreationParams>(),
    );
  });
}
