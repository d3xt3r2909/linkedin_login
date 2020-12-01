import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/client/linked_in_user_widget.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/server/linked_in_auth_code_widget.dart';
import 'package:linkedin_login/src/utils/constants.dart';

void main() {
  LinkedInUserWidget linkedInUserWidget({
    Function(LinkedInUserModel) onGetUserProfile,
    String redirectUrl = 'https://www.app.dexter.com',
    String clientId = '12345',
    String clientSecret = '56789',
    String frontendRedirectUrl,
    bool destroySession = false,
    AppBar appBar,
    List<String> projection = const [
      ProjectionParameters.id,
      ProjectionParameters.localizedFirstName,
      ProjectionParameters.localizedLastName,
      ProjectionParameters.firstName,
      ProjectionParameters.lastName,
    ],
  }) {
    return LinkedInUserWidget(
      onGetUserProfile: onGetUserProfile ?? (LinkedInUserModel response) {},
      redirectUrl: redirectUrl,
      clientId: clientId,
      destroySession: destroySession,
      appBar: appBar,
      clientSecret: clientSecret,
      projection: projection,
    );
  }

  testWidgets('is created', (WidgetTester tester) async {
    linkedInUserWidget();
  });

  testWidgets('is not created when onGetUserProfile callback is null',
      (WidgetTester tester) async {
    expect(
      () => LinkedInUserWidget(
        onGetUserProfile: null,
        redirectUrl: 'redirectUrl',
        clientId: 'clientId',
        clientSecret: 'clientSecret',
      ),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when redirectUrl is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInUserWidget(redirectUrl: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when clientId is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInUserWidget(clientId: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when destroySession is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInUserWidget(destroySession: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when clientSecret is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInUserWidget(clientSecret: null),
      throwsAssertionError,
    );
  });
}
