import 'package:flutter/material.dart';
import 'package:linkedin_login/src/actions.dart';
import 'package:linkedin_login/src/server/fetcher.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/initializer.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:uuid/uuid.dart';

/// This class is responsible to fetch all information for user after we get
/// token and code from LinkedIn
class LinkedInAuthCodeWidget extends StatefulWidget {
  const LinkedInAuthCodeWidget({
    required this.onGetAuthCode,
    required this.redirectUrl,
    required this.clientId,
    required this.onError,
    this.destroySession = false,
    this.frontendRedirectUrl,
    this.appBar,
  });

  final Function(AuthorizationSucceededAction)? onGetAuthCode;
  final Function(AuthorizationFailedAction) onError;
  final String? redirectUrl;
  final String? clientId;
  final AppBar? appBar;
  final bool? destroySession;

  // just in case that frontend in your team has changed redirect url
  final String? frontendRedirectUrl;

  @override
  State createState() => _LinkedInAuthCodeWidgetState();
}

class _LinkedInAuthCodeWidgetState extends State<LinkedInAuthCodeWidget> {
  Graph? graph;

  @override
  void initState() {
    super.initState();

    graph = Initializer().initialise(
      AuthCodeConfiguration(
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
          ServerFetcher(graph: graph, url: config.url)
              .fetchAuthToken()
              .then((action) {
            if (action is AuthorizationSucceededAction) {
              widget.onGetAuthCode?.call(action);
            }

            if (action is AuthorizationFailedAction) {
              widget.onError.call(action);
            }
          });
        },
      ),
    );
  }
}
