import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/utils/overrides.dart';

void main() {
  setUp(() {
    overrides.environment = null;
  });

  test('throw assertion if url is null', () async {
    try {
      Endpoint(Environment.unsupported).generate(
        EnvironmentAccess.profile,
        'path',
      );
    // ignore: avoid_catching_errors
    } on Error catch (e) {
      expect(e, isA<UnsupportedError>());
    }
  });
}
