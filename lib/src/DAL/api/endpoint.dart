import 'package:linkedin_login/src/utils/overrides.dart';

const Map<EnvironmentAccess, String> _kProduction = {
  EnvironmentAccess.profile: 'https://api.linkedin.com',
  EnvironmentAccess.authorization: 'https://www.linkedin.com/oauth',
};
const Map<EnvironmentAccess, String> _kVM = {
  EnvironmentAccess.profile: 'http://localhost:8080',
  EnvironmentAccess.authorization: 'http://localhost:8080/oauth',
};
const Map<EnvironmentAccess, String> _kEmulator = {
  EnvironmentAccess.profile: 'https://10.2.2:8080',
  EnvironmentAccess.authorization: 'https://10.2.2:8080/oauth',
};

class Endpoint {
  Endpoint([
    this.environment = Environment.production,
  ]);

  final Environment environment;

  Map<EnvironmentAccess, String> get _host =>
      _authority(overrides.environment ?? environment);

  Uri generate(
    EnvironmentAccess envSetup,
    String path, [
    Map<String, String>? queryParameters,
  ]) {
    return Uri.parse('${_host[envSetup]}/v2/$path')
        .replace(queryParameters: queryParameters);
  }

  static Map<EnvironmentAccess, String> _authority(Environment environment) {
    switch (environment) {
      case Environment.production:
        return _kProduction;
      case Environment.emulator:
        return _kEmulator;
      case Environment.vm:
        return _kVM;
      default:
        throw UnsupportedError('Unsupported environment $environment');
    }
  }
}

enum Environment {
  emulator,
  production,
  vm,
  unsupported,
}

enum EnvironmentAccess {
  authorization,
  profile,
}
