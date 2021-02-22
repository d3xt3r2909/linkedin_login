import 'package:flutter/material.dart';
import 'package:linkedin_login/src/server/fetcher.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/initializer.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:uuid/uuid.dart';

/// This class is responsible to fetch all information for user after we get
/// token and code from LinkedIn
class LinkedInAuthCodeWidget extends StatefulWidget {
  const LinkedInAuthCodeWidget({
    @required this.onGetAuthCode,
    @required this.redirectUrl,
    @required this.clientId,
    this.destroySession = false,
    this.frontendRedirectUrl,
    this.appBar,
  })  : assert(onGetAuthCode != null),
        assert(redirectUrl != null),
        assert(clientId != null),
        assert(destroySession != null);

  final Function(AuthorizationCodeResponse) onGetAuthCode;
  final String redirectUrl;
  final String clientId;
  final AppBar appBar;
  final bool destroySession;

  // just in case that frontend in your team has changed redirect url
  final String frontendRedirectUrl;

  @override
  State createState() => _LinkedInAuthCodeWidgetState();
}

class _LinkedInAuthCodeWidgetState extends State<LinkedInAuthCodeWidget> {
  Graph graph;

  @override
  void initState() {
    super.initState();

    graph = Initializer().initialise(
      AuthCodeConfig(
        urlState: Uuid().v4(),
        redirectUrlParam: widget.redirectUrl,
        clientIdParam: widget.clientId,
        frontendRedirectUrlParam: widget.frontendRedirectUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InjectorWidget(
      graph: graph,
      child: LinkedInWebViewHandler(
        appBar: widget.appBar,
        destroySession: widget.destroySession,
        onUrlMatch: (config) {
          ServerFetcher(graph, config.url).fetchAuthToken().then(
            (code) {
              widget.onGetAuthCode(code);
            },
          );
        },
      ),
    );
  }
}
