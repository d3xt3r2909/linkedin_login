import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/DAL/api/exceptions.dart';

void main() {
  group('HttpResponseException', () {
    test('throw assertion if url is null', () async {
      expect(
        () => HttpResponseException(
          url: null,
          statusCode: 400,
        ),
        throwsAssertionError,
      );
    });

    test('throw assertion if code is null', () async {
      expect(
        () => HttpResponseException(
          url: Uri.parse('https://domen.com'),
          statusCode: null,
        ),
        throwsAssertionError,
      );
    });
  });

  group('AuthCodeException', () {
    test('throw assertion if authCode is null', () async {
      expect(
        () => AuthCodeException(authCode: null, description: 'description'),
        throwsAssertionError,
      );
    });

    test('throw assertion if description is null', () async {
      expect(
        () => AuthCodeException(authCode: 'authCode', description: null),
        throwsAssertionError,
      );
    });

    test('test toString method', () async {
      final exception =
          AuthCodeException(authCode: 'authCode', description: 'description');
      expect(
        exception.toString(),
        equals(
          'AuthCodeException:: for authCode: authCode with description: description',
        ),
      );
    });
  });
}
