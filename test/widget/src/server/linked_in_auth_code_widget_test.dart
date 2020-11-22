import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/server/linked_in_auth_code_widget.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';

void main() {
  LinkedInAuthCodeWidget linkedInAuthCodeWidget({
    Function(AuthorizationCodeResponse) onGetAuthCode,
    String redirectUrl = 'https://www.app.dexter.com',
    String clientId = '12345',
    String frontendRedirectUrl,
    bool destroySession = false,
    AppBar appBar,
  }) {
    return LinkedInAuthCodeWidget(
      onGetAuthCode: onGetAuthCode ?? (AuthorizationCodeResponse response) {},
      redirectUrl: redirectUrl,
      clientId: clientId,
      frontendRedirectUrl: frontendRedirectUrl,
      destroySession: destroySession,
      appBar: appBar,
      catchError: () {},
    );
  }

  testWidgets('is created', (WidgetTester tester) async {
    linkedInAuthCodeWidget();
  });

  testWidgets('is not created when onGetAuthCode callback is null',
      (WidgetTester tester) async {
    expect(
      () => LinkedInAuthCodeWidget(
        onGetAuthCode: null,
        redirectUrl: '',
        clientId: '',
      ),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when redirectUrl is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInAuthCodeWidget(redirectUrl: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when clientId is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInAuthCodeWidget(clientId: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when destroySession is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInAuthCodeWidget(destroySession: null),
      throwsAssertionError,
    );
  });
}
