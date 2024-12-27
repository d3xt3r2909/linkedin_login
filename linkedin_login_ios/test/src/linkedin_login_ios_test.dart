import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login_ios/src/linkedin_login_ios.dart';
import 'package:linkedin_login_platform_interface/linkedin_login_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LinkedinLoginPlatform tested;

  setUp(() => tested = LinkedinLoginIos());

  test(
      'will return $WebKitWebViewControllerCreationParams '
      'when calling getter for param', () async {
    expect(
      tested.platformWebControllerParam,
      isA<WebKitWebViewControllerCreationParams>(),
    );
  });
}
