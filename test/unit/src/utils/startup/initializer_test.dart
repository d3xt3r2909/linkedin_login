import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/initializer.dart';
import 'package:test/test.dart';

void main() {
  test('is graph created with init', () async {
    final graph = Initializer().initialise(
      AccessCodeConfiguration(
        projectionParam: ProjectionParameters.fullProjection,
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
    expect(graph.linkedInConfiguration.projection.length, 5);
  });
}
