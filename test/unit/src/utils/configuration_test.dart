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
        scopeParam: const ['scope1'],
      );

      expect(config.frontendRedirectUrl, isNull);
    });

    test(
        'initial URL should use parameters from config when scope is '
        'not existing', () {
      final config = AccessCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        clientSecretParam: 'clientSecretParam',
        projectionParam: const ['projection'],
        scopeParam: null,
      );

      expect(
        config.initialUrl,
        'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=clientIdParam&state=urlState&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress',
      );
    });

    test('initial URL should use parameters from config when scope is existing',
        () {
      final config = AccessCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        clientSecretParam: 'clientSecretParam',
        projectionParam: const ['projection'],
        scopeParam: const ['scope1', 'scope2'],
      );

      expect(
        config.initialUrl,
        'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=clientIdParam&state=urlState&redirect_uri=https://www.app.dexter.com&scope=scope1%20scope2',
      );
    });

    test('redirection url starts with redirected parameter', () {
      final config = AccessCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        clientSecretParam: 'clientSecretParam',
        projectionParam: const ['projection'],
        scopeParam: const ['scope1'],
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
        scopeParam: const ['scope1'],
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
        scopeParam: const ['scope1'],
      );

      expect(config.frontendRedirectUrl, isNull);
    });

    test('frontendRedirectUrl can have an value', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        frontendRedirectUrlParam: 'frontendRedirectUrlParam',
        scopeParam: const ['scope1'],
      );

      expect(config.frontendRedirectUrl, 'frontendRedirectUrlParam');
    });

    test('clientSecret for this class is not existing', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopeParam: const ['scope1'],
      );

      expect(config.frontendRedirectUrl, isNull);
    });

    test('projection for this class is not existing', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopeParam: const ['scope1'],
      );

      expect(config.projection, isNull);
    });

    test(
        'initial URL should use parameters from config when scope are not '
        'existing', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopeParam: null,
      );

      expect(
        config.initialUrl,
        'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=clientIdParam&state=urlState&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress',
      );
    });

    test(
        'initial URL should use parameters from config when scope are '
        'existing', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopeParam: const ['scope1', 'scope2'],
      );

      expect(
        config.initialUrl,
        'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=clientIdParam&state=urlState&redirect_uri=https://www.app.dexter.com&scope=scope1%20scope2',
      );
    });

    test(
        'redirection url starts with redirected parameter, frontend '
        'redirection not exists', () {
      final config = AuthCodeConfiguration(
        redirectUrlParam: 'https://www.app.dexter.com',
        clientIdParam: 'clientIdParam',
        urlState: 'urlState',
        scopeParam: const ['scope1'],
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
        scopeParam: const ['scope1'],
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
        scopeParam: const ['scope1'],
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
