import 'package:flutter/material.dart';
import 'package:linkedin_login/src/actions.dart';
import 'package:linkedin_login/src/client/fetcher.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/scopes.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/initializer.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:uuid/uuid.dart';

/// This class is responsible to fetch all information for user after we get
/// token and code from LinkedIn
/// Please look at documentation for minimum SDK version if you are using
/// [useVirtualDisplay] by default library is using `Hybrid Composition` which
/// requires minSdkVersion to be 19
class LinkedInUserWidget extends StatefulWidget {
  /// Client state parameter needs to be unique range of characters - random one
  const LinkedInUserWidget({
    required this.onGetUserProfile,
    required this.redirectUrl,
    required this.clientId,
    required this.clientSecret,
    this.onError,
    this.destroySession = false,
    this.appBar,
    this.useVirtualDisplay = false,
    this.scope = const [
      OpenIdScope(),
      EmailScope(),
      ProfileScope(),
    ],
    super.key,
  });

  final ValueChanged<UserSucceededAction>? onGetUserProfile;
  final ValueChanged<UserFailedAction>? onError;
  final String? redirectUrl;
  final String? clientId;
  final String? clientSecret;
  final PreferredSizeWidget? appBar;
  final bool destroySession;
  final bool useVirtualDisplay;
  final List<Scope> scope;

  @override
  State createState() => _LinkedInUserWidgetState();
}

/// Class [_LinkedInUserWidgetState] is handling changes after user is singed in
/// which will have as result user profile on the end
class _LinkedInUserWidgetState extends State<LinkedInUserWidget> {
  late Graph graph;

  @override
  void initState() {
    super.initState();

    graph = Initializer().initialise(
      AccessCodeConfiguration(
        clientSecretParam: widget.clientSecret,
        clientIdParam: widget.clientId,
        redirectUrlParam: widget.redirectUrl,
        urlState: const Uuid().v4(),
        scopeParam: widget.scope,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return InjectorWidget(
      graph: graph,
      child: LinkedInWebViewHandler(
        appBar: widget.appBar,
        destroySession: widget.destroySession,
        useVirtualDisplay: widget.useVirtualDisplay,
        onUrlMatch: (final config) {
          ClientFetcher(
            graph: graph,
            url: config.url,
          ).fetchUser().then(
            (final action) {
              if (action is UserSucceededAction) {
                widget.onGetUserProfile?.call(action);
              }

              if (action is UserFailedAction) {
                widget.onError?.call(action);
              }
            },
          );
        },
      ),
    );
  }
}
