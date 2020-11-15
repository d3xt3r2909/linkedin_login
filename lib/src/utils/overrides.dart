import 'package:linkedin_login/src/DAL/api/endpoint.dart';

Overrides overrides = Overrides();

class Overrides {
  Environment environment;

  void dispose() {
    environment = null;
  }
}
