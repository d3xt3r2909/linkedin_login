import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/utils/configuration.dart';

void main() {
  group('AccessCodeConfiguration class', () {
    test('frontendRedirectUrl for this class is not existing', () {
      final config = AccessCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        clientSecretParam: 'clientSecretParam',
        projectionParam: const ['projection'],
        scopes: const [
          Scopes.readLiteProfile,
          Scopes.readEmailAddress,
        ],
      );

      expect(config.frontendRedirectUrl, isNull);
    });

    test('initial URL should use parameters from config', () {
      final config = AccessCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        clientSecretParam: 'clientSecretParam',
        projectionParam: const ['projection'],
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(config.initialUri.toString(),
          'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=clientIdParam&state=urlState&redirect_uri=https%3A%2F%2Fwww.app.dexter.com&scope=r_emailaddress+r_liteprofile',);
    });

    test('redirection url starts with redirected parameter', () {
      final config = AccessCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        clientSecretParam: 'clientSecretParam',
        projectionParam: const ['projection'],
        scopes: const [
          Scopes.readLiteProfile,
          Scopes.readEmailAddress,
        ],
      );

      expect(
        config.isCurrentUrlMatchToRedirection(
          'https://www.app.dexter.com?code=xxx',
        ),
        isTrue,
      );
    });

    test('redirection url is not starting with redirected parameter', () {
      final config = AccessCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        clientSecretParam: 'clientSecretParam',
        projectionParam: const ['projection'],
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(
        config.isCurrentUrlMatchToRedirection(
          'https://www.something.com?code=xxx',
        ),
        isFalse,
      );
    });
  });

  group('AuthCodeConfig class', () {
    test('frontendRedirectUrl can be null', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(config.frontendRedirectUrl, isNull);
    });

    test('frontendRedirectUrl can have an value', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        frontendRedirectUrlParam: 'frontendRedirectUrlParam',
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(config.frontendRedirectUrl, 'frontendRedirectUrlParam');
    });

    test('clientSecret for this class is not existing', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(config.frontendRedirectUrl, isNull);
    });

    test('projection for this class is not existing', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(config.projection, isNull);
    });

    test('initial URL should use parameters from config', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(
        config.initialUri.toString(),
        'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=clientIdParam&state=urlState&redirect_uri=https%3A%2F%2Fwww.app.dexter.com&scope=r_emailaddress+r_liteprofile',
      );
    });

    test(
        'redirection url starts with redirected parameter, frontend '
        'redirection not exists', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(
        config.isCurrentUrlMatchToRedirection(
          'https://www.app.dexter.com?code=xxx',
        ),
        isTrue,
      );
    });

    test(
        'redirection url is not starting with redirected parameter but '
        'frontend redirection does', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        frontendRedirectUrlParam: 'https://www.frontend.com',
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(
        config.isCurrentUrlMatchToRedirection('https://www.frontend.com'),
        isTrue,
      );
    });

    test(
        'redirection url is not starting with redirected parameter neither '
        'with frontend redirection parameter', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        frontendRedirectUrlParam: 'https://www.frontend.com',
        scopes: const [
          Scopes.readEmailAddress,
          Scopes.readLiteProfile,
        ],
      );

      expect(
        config.isCurrentUrlMatchToRedirection(
          'https://www.something.com?code=xxx',
        ),
        isFalse,
      );
    });
  });
}
