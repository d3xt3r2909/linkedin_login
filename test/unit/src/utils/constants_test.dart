import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';

void main() {
  group('ProjectionParameters class', () {
    test('Id constant should have id value', () {
      expect(ProjectionParameters.id, 'id');
    });

    test('localizedLastName constant should have localizedLastName value', () {
      expect(ProjectionParameters.localizedLastName, 'localizedLastName');
    });

    test('firstName constant should have firstName value', () {
      expect(ProjectionParameters.firstName, 'firstName');
    });

    test('lastName constant should have lastName value', () {
      expect(ProjectionParameters.lastName, 'lastName');
    });

    test('localizedFirstName constant should have localizedFirstName value', () {
      expect(ProjectionParameters.localizedFirstName, 'localizedFirstName');
    });

    test('profilePicture constant should have profilePicture(displayImage~:playableStreams) value', () {
      expect(ProjectionParameters.profilePicture, 'profilePicture(displayImage~:playableStreams)');
    });
  });

  group('UrlAccessPoint class', () {
    test('URL_LINKED_IN_GET_ACCESS_TOKEN constant should have https://www.linkedin.com/oauth/v2/accessToken value', () {
      expect(UrlAccessPoint.URL_LINKED_IN_GET_ACCESS_TOKEN, 'https://www.linkedin.com/oauth/v2/accessToken');
    });

    test('URL_LINKED_IN_GET_AUTH_TOKEN constant should have https://www.linkedin.com/oauth/v2/authorization value', () {
      expect(UrlAccessPoint.URL_LINKED_IN_GET_AUTH_TOKEN, 'https://www.linkedin.com/oauth/v2/authorization');
    });
  });
}
