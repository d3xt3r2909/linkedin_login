import 'package:flutter_test/flutter_test.dart';
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
      );

      expect(config.initialUrl,
          'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=clientIdParam&state=urlState&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress');
    });

    test('redirection url starts with redirected parameter', () {
      final config = AccessCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        clientSecretParam: 'clientSecretParam',
        projectionParam: const ['projection'],
      );

      expect(
        config.isCurrentUrlMatchToRedirection(
            'https://www.app.dexter.com?code=xxx'),
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
      );

      expect(
        config.isCurrentUrlMatchToRedirection(
            'https://www.something.com?code=xxx'),
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
      );

      expect(config.frontendRedirectUrl, isNull);
    });

    test('frontendRedirectUrl can have an value', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        frontendRedirectUrlParam: 'frontendRedirectUrlParam',
      );

      expect(config.frontendRedirectUrl, 'frontendRedirectUrlParam');
    });

    test('clientSecret for this class is not existing', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
      );

      expect(config.frontendRedirectUrl, isNull);
    });

    test('projection for this class is not existing', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
      );

      expect(config.projection, isNull);
    });

    test('initial URL should use parameters from config', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
      );

      expect(config.initialUrl,
          'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=clientIdParam&state=urlState&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress');
    });

    test(
        'redirection url starts with redirected parameter, frontend redirection not exists',
        () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
      );

      expect(
        config.isCurrentUrlMatchToRedirection(
            'https://www.app.dexter.com?code=xxx'),
        isTrue,
      );
    });

    test(
        'redirection url is not starting with redirected parameter but frontend redirection does',
        () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        frontendRedirectUrlParam: 'https://www.frontend.com',
      );

      expect(
        config.isCurrentUrlMatchToRedirection('https://www.frontend.com'),
        isTrue,
      );
    });

    test(
        'redirection url is not starting with redirected parameter neither with frontend redirection parameter',
        () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        frontendRedirectUrlParam: 'https://www.frontend.com',
      );

      expect(
        config.isCurrentUrlMatchToRedirection(
            'https://www.something.com?code=xxx'),
        isFalse,
      );
    });
  });
}
