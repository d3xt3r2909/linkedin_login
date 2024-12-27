import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/webview/controller_builder.dart';

@immutable
class Graph {
  const Graph({
    required this.authorizationRepository,
    required this.userRepository,
    required this.api,
    required this.linkedInConfiguration,
    required this.httpClient,
    required this.webViewControllerBuilder,
  });

  final AuthorizationRepository authorizationRepository;
  final UserRepository userRepository;
  final LinkedInApi api;
  final Config linkedInConfiguration;
  final http.Client httpClient;
  final WebViewControllerBuilder webViewControllerBuilder;
}
