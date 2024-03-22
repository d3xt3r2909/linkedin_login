import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/scopes.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/initializer.dart';
import 'package:test/test.dart';

void main() {
  test('is graph created with init', () async {
    final graph = Initializer().initialise(
      AccessCodeConfiguration(
        clientSecretParam: 'clientSecretParam',
        urlState: 'urlState',
        clientIdParam: 'clientIdParam',
        redirectUrlParam: 'redirectUrlParam',
        scopeParam: const [OpenIdScope(), EmailScope(), ProfileScope()],
      ),
    );

    expect(graph, isA<Graph>());
    expect(graph.linkedInConfiguration.state, 'urlState');
    expect(graph.linkedInConfiguration.clientSecret, 'clientSecretParam');
    expect(graph.linkedInConfiguration.redirectUrl, 'redirectUrlParam');
    expect(graph.linkedInConfiguration.frontendRedirectUrl, isNull);
    expect(graph.linkedInConfiguration.state, 'urlState');
    expect(
      graph.linkedInConfiguration.parseScopesToQueryParam(
        const [OpenIdScope(), EmailScope(), ProfileScope()],
      ),
      'openid%20email%20profile',
    );
  });

  test('is graph created with init for AuthCodeConfig', () async {
    final graph = Initializer().initialise(
      AuthCodeConfiguration(
        urlState: 'urlState',
        clientIdParam: 'clientIdParam',
        redirectUrlParam: 'redirectUrlParam',
        frontendRedirectUrlParam: 'frontendRedirectUrlParam',
        scopeParam: const [EmailScope()],
      ),
    );

    expect(graph, isA<Graph>());
    expect(graph.linkedInConfiguration.state, 'urlState');
    expect(graph.linkedInConfiguration.redirectUrl, 'redirectUrlParam');
    expect(graph.linkedInConfiguration.state, 'urlState');
    expect(
      graph.linkedInConfiguration.frontendRedirectUrl,
      'frontendRedirectUrlParam',
    );
    expect(graph.linkedInConfiguration.clientSecret, isNull);
    expect(
      graph.linkedInConfiguration.parseScopesToQueryParam(const [EmailScope()]),
      'email',
    );
  });
}
