import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';

void main() {
  test('$EmailScope is a $Scope', () {
    expect(const EmailScope(), isA<Scope>());
  });

  test('$EmailScope has proper string permission', () {
    expect(const EmailScope().permission, equals('email'));
  });

  test('$ProfileScope is a $Scope', () {
    expect(const ProfileScope(), isA<Scope>());
  });

  test('$ProfileScope has proper string permission', () {
    expect(const ProfileScope().permission, equals('profile'));
  });

  test('$OpenIdScope is a $Scope', () {
    expect(const OpenIdScope(), isA<Scope>());
  });

  test('$OpenIdScope has proper string permission', () {
    expect(const OpenIdScope().permission, equals('openid'));
  });
}
