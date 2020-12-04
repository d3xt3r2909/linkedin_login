import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/client/state.dart';

void main() {
  _ArrangeBuilder builder;

  setUp(() {
    builder = _ArrangeBuilder();
  });

  test('Do not create it if the linkedInUser is null', () async {
    expect(
      () => LinkedInUserState(
        linkedInUser: null,
      ),
      throwsAssertionError,
    );
  });

  test('copy - default value is taken', () async {
    final responsePath = '${builder.testPath}full_user_profile.json';
    final fileContent = await builder.getResponseFileContent(responsePath);

    final state = LinkedInUserState(
      linkedInUser: LinkedInUserModel.fromJson(
        json.decode(fileContent),
      ),
    );

    final newState = state.copyWith();

    expect(
      newState.linkedInUser.userId,
      'dwe_Pcc0k3',
    );
  });

  test('copy - parameter value is taken', () async {
    final noIdPath = '${builder.testPath}user_profile_no_id.json';
    final fileContentWithoutId = await builder.getResponseFileContent(noIdPath);

    final state = LinkedInUserState(
      linkedInUser: LinkedInUserModel.fromJson(
        json.decode(fileContentWithoutId),
      ),
    );

    expect(state.linkedInUser.userId, isNull);

    final withIdPath = '${builder.testPath}full_user_profile.json';
    final fileContentWithId = await builder.getResponseFileContent(withIdPath);

    final newState = state.copyWith(
      linkedInUser: LinkedInUserModel.fromJson(
        json.decode(fileContentWithId),
      ),
    );

    expect(newState.linkedInUser.userId, 'dwe_Pcc0k3');
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
