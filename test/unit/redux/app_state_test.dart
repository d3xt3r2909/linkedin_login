import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/client/state.dart';
import 'package:linkedin_login/src/server/state.dart';

void main() {
  _ArrangeBuilder builder;

  setUp(() {
    builder = _ArrangeBuilder();
  });

  test('Do not create it if the user state is null', () async {
    expect(
      () => AppState(
        linkedInUserState: null,
        userAuthCodeState: UserAuthCodeState.initialState(),
      ),
      throwsAssertionError,
    );
  });

  test('Do not create it if the auth code state is null', () async {
    expect(
      () => AppState(
        linkedInUserState: LinkedInUserState.initialState(),
        userAuthCodeState: null,
      ),
      throwsAssertionError,
    );
  });

  test('copy - parameter value is taken', () async {
    final responsePath = '${builder.testPath}full_user_profile.json';
    final fileContent = await builder.getResponseFileContent(responsePath);

    final state = AppState(
      linkedInUserState: LinkedInUserState.initialState(),
      userAuthCodeState: UserAuthCodeState.initialState(),
    );

    final newState = state.copyWith(
      linkedInUserState: LinkedInUserState.initialState().copyWith(
        linkedInUser: LinkedInUserModel.fromJson(
          json.decode(fileContent),
        ),
      ),
      userAuthCodeState: UserAuthCodeState.initialState().copyWith(
        userAuthCode: AuthorizationCodeResponse(
          code: 'testCode',
        ),
      ),
    );

    expect(
      newState.linkedInUserState.linkedInUser.userId,
      'dwe_Pcc0k3',
    );
    expect(
      newState.userAuthCodeState.userAuthCode.code,
      'testCode',
    );
  });

  test('copy - default value is taken', () async {
    final responsePath = '${builder.testPath}full_user_profile.json';
    final fileContent = await builder.getResponseFileContent(responsePath);

    final state = AppState(
      linkedInUserState: LinkedInUserState.initialState().copyWith(
        linkedInUser: LinkedInUserModel.fromJson(
          json.decode(fileContent),
        ),
      ),
      userAuthCodeState: UserAuthCodeState.initialState().copyWith(
        userAuthCode: AuthorizationCodeResponse(
          code: 'codeTest',
        ),
      ),
    );

    final newState = state.copyWith();

    expect(
      newState.linkedInUserState.linkedInUser.userId,
      'dwe_Pcc0k3',
    );
    expect(
      newState.userAuthCodeState.userAuthCode.code,
      'codeTest',
    );
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder();

  Future<String> getResponseFileContent(String pathToFile) async {
    final file = File(pathToFile);
    return file.readAsString();
  }

  String get testPath =>
      '${Directory.current.path.endsWith('test') ? '.' : './test'}/unit/src/DAL/api/override/';
}
