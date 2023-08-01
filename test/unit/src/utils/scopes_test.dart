import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';

void main() {
  test('$EmailAddressScope is a $Scope', () {
    expect(const EmailAddressScope(), isA<Scope>());
  });

  test('$EmailAddressScope has proper string permission', () {
    expect(const EmailAddressScope().permission, equals('r_emailaddress'));
  });

  test('$LiteProfileScope is a $Scope', () {
    expect(const LiteProfileScope(), isA<Scope>());
  });

  test('$LiteProfileScope has proper string permission', () {
    expect(const LiteProfileScope().permission, equals('r_liteprofile'));
  });
}
