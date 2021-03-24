import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/initializer.dart';
import 'package:test/test.dart';

void main() {
  test('is graph created with init', () async {
    final graph = Initializer().initialise(
      AccessCodeConfiguration(
        projectionParam: ProjectionParameters.projectionWithoutPicture,
        clientSecretParam: 'clientSecretParam',
        urlState: 'urlState',
        clientIdParam: 'clientIdParam',
        redirectUrlParam: 'redirectUrlParam',
      ),
    );

    expect(graph, isA<Graph>());
    expect(graph.linkedInConfiguration.state, 'urlState');
    expect(graph.linkedInConfiguration.clientSecret, 'clientSecretParam');
    expect(graph.linkedInConfiguration.redirectUrl, 'redirectUrlParam');
    expect(graph.linkedInConfiguration.frontendRedirectUrl, isNull);
    expect(graph.linkedInConfiguration.state, 'urlState');
    expect(graph.linkedInConfiguration.projection!.length, 5);
  });

  test('is graph created with init for AuthCodeConfig', () async {
    final graph = Initializer().initialise(
      AuthCodeConfiguration(
        urlState: 'urlState',
        clientIdParam: 'clientIdParam',
        redirectUrlParam: 'redirectUrlParam',
        frontendRedirectUrlParam: 'frontendRedirectUrlParam',
      ),
    );

    expect(graph, isA<Graph>());
    expect(graph.linkedInConfiguration.state, 'urlState');
    expect(graph.linkedInConfiguration.redirectUrl, 'redirectUrlParam');
    expect(graph.linkedInConfiguration.state, 'urlState');
    expect(graph.linkedInConfiguration.frontendRedirectUrl,
        'frontendRedirectUrlParam');
    expect(graph.linkedInConfiguration.projection, isNull);
    expect(graph.linkedInConfiguration.clientSecret, isNull);
  });
}
