import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/DAL/api/exceptions.dart';

void main() {
  group('AuthCodeException', () {
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
