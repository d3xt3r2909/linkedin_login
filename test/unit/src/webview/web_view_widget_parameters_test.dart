import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';

void main() {
  group('AccessCodeConfig class', () {
    test('Is created', () {
      AccessCodeConfig(
        redirectUrl: 'N/A',
        clientId: 'N/A',
        clientSecretParam: 'NR/A',
        projectionParam: ['N/A'],
      );
    });

    test('Throws assertion if redirect url is null', () {
      expect(
        () => AccessCodeConfig(
          redirectUrl: null,
          clientId: 'N/A',
          clientSecretParam: 'N/A',
          projectionParam: ['N/A'],
        ),
        throwsAssertionError,
      );
    });

    test('Throws assertion if client id is null', () {
      expect(
        () => AccessCodeConfig(
          redirectUrl: 'https://test.com',
          clientId: null,
          clientSecretParam: 'N/A',
          projectionParam: ['N/A'],
        ),
        throwsAssertionError,
      );
    });

    test('Throws assertion if client secret is null', () {
      expect(
        () => AccessCodeConfig(
          redirectUrl: 'https://test.com',
          clientId: 'N/A',
          clientSecretParam: null,
          projectionParam: ['N/A'],
        ),
        throwsAssertionError,
      );
    });

    test('Throws assertion if projection is null', () {
      expect(
        () => AccessCodeConfig(
          redirectUrl: 'https://test.com',
          clientId: 'N/A',
          clientSecretParam: 'N/A',
          projectionParam: null,
        ),
        throwsAssertionError,
      );
    });

    test('If parameter match to redirectUrl return truE', () {
      final isUrlRedirection = AccessCodeConfig(
        clientId: 'N/A',
        clientSecretParam: 'N/A',
        projectionParam: ['N/A'],
        redirectUrl: 'https://test.com',
      ).isCurrentUrlMatchToRedirection('https://test.com');

      expect(isUrlRedirection, isTrue);
    });

    test('If parameter does not match to redirectUrl return false', () {
      final isUrlRedirection = AccessCodeConfig(
        clientId: 'N/A',
        clientSecretParam: 'N/A',
        projectionParam: ['N/A'],
        redirectUrl: 'https://test.com',
      ).isCurrentUrlMatchToRedirection('https://something.com');

      expect(isUrlRedirection, isFalse);
    });
  });

  group('AuthCodeConfig class', () {
    test('Is created', () {
      AuthCodeConfig(
        redirectUrl: 'N/A',
        clientId: 'N/A',
      );
    });

    test('Throws assertion if redirect url is null', () {
      expect(
        () => AuthCodeConfig(
          redirectUrl: null,
          clientId: 'N/A',
        ),
        throwsAssertionError,
      );
    });

    test('Throws assertion if client id is null', () {
      expect(
        () => AuthCodeConfig(
          redirectUrl: 'N/A',
          clientId: null,
        ),
        throwsAssertionError,
      );
    });

    test(
        'If parameter match to redirectUrl return true, frontend url not provided',
        () {
      final isUrlRedirection = AuthCodeConfig(
        redirectUrl: 'https://test.com',
        clientId: 'N/A',
      ).isCurrentUrlMatchToRedirection('https://test.com');

      expect(isUrlRedirection, isTrue);
    });

    test('If parameter does not match to redirectUrl return false, frontend redirection not provided', () {
      final isUrlRedirection = AuthCodeConfig(
        redirectUrl: 'https://test.com',
        clientId: 'N/A',
      ).isCurrentUrlMatchToRedirection('https://something.com');

      expect(isUrlRedirection, isFalse);
    });

    test('If parameter does not match to redirectUrl return false, frontend redirection matches', () {
      final isUrlRedirection = AuthCodeConfig(
        redirectUrl: 'https://test.com',
        clientId: 'N/A',
        frontendRedirectUrlParam: 'https://something.com',
      ).isCurrentUrlMatchToRedirection('https://something.com');

      expect(isUrlRedirection, isTrue);
    });

    test('If parameter does not match to redirectUrl return false, frontend redirection not matching', () {
      final isUrlRedirection = AuthCodeConfig(
        redirectUrl: 'https://test.com',
        clientId: 'N/A',
        frontendRedirectUrlParam: 'https://something.com',
      ).isCurrentUrlMatchToRedirection('https://somethingelse.com');

      expect(isUrlRedirection, isFalse);
    });
  });
}
